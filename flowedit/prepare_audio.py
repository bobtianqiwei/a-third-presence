# prepare_audio.py developed by Bob Tianqi Wei
"""Prepare an offline sequence using the course notebook's HTTPS API."""
import base64
from datetime import datetime, timezone
import io
import json
import os
from pathlib import Path
import shutil
import tempfile
import sys

import requests
import soundfile as sf

ROOT = Path(__file__).resolve().parents[1]
HUB = 'https://audioflow.csail.mit.edu'
NUM_INTERMEDIATES = 9
NOTEBOOK = 'https://github.com/jon-myers/flowedit-notebook/blob/main/flowedit_api.ipynb'


def validate_wav(data, name):
    info = sf.info(io.BytesIO(data))
    if info.format != 'WAV' or info.frames == 0 or not 0 < info.duration <= 47:
        raise ValueError(f'{name} must be a nonempty WAV of at most 47 seconds.')
    if info.channels not in (1, 2):
        raise ValueError(f'{name} must be mono or stereo.')
    return info


def request(session, path, body, timeout):
    response = session.post(HUB + path, json=body, timeout=(30, timeout))
    if not response.ok:
        raise RuntimeError(f'FlowEdit request failed: HTTP {response.status_code}. Check your key and service availability.')
    return response.json(), response.headers


def describe(session, data):
    result, _ = request(session, '/describe',
                        {'audio_b64': base64.b64encode(data).decode(), 'words': 40}, 120)
    caption = result['caption']
    if not isinstance(caption, str) or not caption.strip():
        raise ValueError('FlowEdit returned an empty caption.')
    return caption


def save_sequence(a, b, result, descriptions, output, headers, include_b=True, extra_metadata=None):
    slots = sorted(result['intermediates'],
                   key=lambda slot: -float(slot['label'].removeprefix('t=')))
    if len(slots) != NUM_INTERMEDIATES:
        raise ValueError('FlowEdit returned an unexpected number of intermediate sounds.')
    files = [('00_A.wav', a)]
    for i, slot in enumerate(slots, 1):
        files.append((f'{i:02d}_intermediate.wav', base64.b64decode(slot['audio_b64'], validate=True)))
    files.append((f'{len(files):02d}_AI_target.wav', base64.b64decode(result['final']['audio_b64'], validate=True)))
    if include_b:
        files.append((f'{len(files):02d}_B.wav', b))
    for name, data in files:
        validate_wav(data, name)
    output.parent.mkdir(parents=True, exist_ok=True)
    backup = output.with_name(output.name + '.previous')
    if backup.exists():
        raise ValueError(f'Previous backup exists: {backup}. Inspect it before generating again.')
    with tempfile.TemporaryDirectory(prefix='.flowedit-', dir=output.parent) as temp:
        staged = Path(temp) / 'generated'
        staged.mkdir()
        for name, data in files:
            (staged / name).write_bytes(data)
        metadata = dict(participant_a_description=descriptions[0],
                        participant_b_description=descriptions[1],
                        num_generated_intermediates=len(slots),
                        generated_at=datetime.now(timezone.utc).isoformat(),
                        files=[name for name, _ in files], seed=result['seed'],
                        intermediate_labels=[s['label'] for s in slots],
                        notebook=NOTEBOOK, endpoint=HUB,
                        queued_seconds=headers.get('X-FlowEdit-Queued-S'),
                        render_seconds=headers.get('X-FlowEdit-Render-S'))
        metadata.update(extra_metadata or {})
        (staged / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
        if output.exists():
            output.rename(backup)
        try:
            staged.rename(output)
        except OSError:
            if backup.exists():
                backup.rename(output)
            raise
        if backup.exists():
            shutil.rmtree(backup)
    return metadata


def main():
    try:
        inputs = [ROOT / 'audio/input' / f'{label}.wav' for label in 'AB']
        for path in inputs:
            if not path.is_file():
                raise ValueError(f'Missing input WAV: {path}. Add your recording and run again.')
        audio = [path.read_bytes() for path in inputs]
        infos = [validate_wav(data, path.name) for data, path in zip(audio, inputs)]
        key = os.environ.get('FLOWEDIT_KEY', '').strip()
        key_file = Path.home() / 'Library/Application Support/A Third Presence/flowedit.key'
        if not key and key_file.is_file():
            key = key_file.read_text().strip()
        if not key:
            raise ValueError('FLOWEDIT_KEY is not set. Run: export FLOWEDIT_KEY="your-personal-key"')
        with requests.Session() as session:
            session.headers['Authorization'] = f'Bearer {key}'
            descriptions = []
            for label, data in zip('AB', audio):
                print(f'Describing Participant {label} audio...', flush=True)
                caption = describe(session, data)
                descriptions.append(caption)
                print(f'Participant {label} description:\n{caption}', flush=True)
            body = dict(src_prompt=descriptions[0], tar_prompt=descriptions[1],
                        audio_b64=base64.b64encode(audio[0]).decode(),
                        seconds_total=max(1, min(47, round(infos[0].duration))),
                        lfe_steps=20, n_avg=10, src_lfe_cfg_scale=1.0,
                        tar_lfe_cfg_scale=5.0, num_intermediates=NUM_INTERMEDIATES,
                        even_steps=True, seed=-1)
            print('Generating audio. Waiting in the server queue may take up to 45 minutes.', flush=True)
            result, headers = request(session, '/generate', body, 2700)
        metadata = save_sequence(*audio, result, descriptions, ROOT / 'audio/generated', headers)
        print(f"Saved {len(metadata['files'])} WAV files to {ROOT / 'audio/generated'}.")
        return 0
    except (requests.RequestException, ValueError, KeyError, TypeError, OSError, RuntimeError) as error:
        print(f'Error: {error}', file=sys.stderr)
        print('Existing generated audio was preserved. Check inputs, key, and service status before retrying.', file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print('\nAudio preparation cancelled. Existing generated audio was preserved.')
        return 130


if __name__ == '__main__':
    raise SystemExit(main())
