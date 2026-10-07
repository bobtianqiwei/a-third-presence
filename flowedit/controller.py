# controller.py developed by Bob Tianqi Wei
"""Local OSC controller for Max recording and offline FlowEdit jobs."""
import base64
import hashlib
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import threading
import time

import requests
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import OSCUDPServer
from pythonosc.udp_client import SimpleUDPClient

try:
    from .prepare_audio import ROOT, NUM_INTERMEDIATES, describe, request, save_sequence, validate_wav
except ImportError:
    from prepare_audio import ROOT, NUM_INTERMEDIATES, describe, request, save_sequence, validate_wav

KEY_FILE = Path.home() / 'Library/Application Support/A Third Presence/flowedit.key'
CACHE = ROOT / 'audio/prompt.json'


def load_key():
    key = os.environ.get('FLOWEDIT_KEY', '').strip()
    if not key and KEY_FILE.is_file():
        key = KEY_FILE.read_text().strip()
    if not key:
        raise ValueError('No local FlowEdit key found.')
    return key


def read_audio(label):
    path = ROOT / 'audio/input' / (label + '.wav')
    if not path.is_file():
        raise ValueError('Record ' + label + ' and click Stop Recording first.')
    data = path.read_bytes()
    return data, validate_wav(data, label + '.wav')


class Controller:
    def __init__(self):
        self.client = SimpleUDPClient('127.0.0.1', 9000)
        self.status = 'System ready. Record A and B, then generate B prompt.'
        self.prompt = ''
        self.prompt_a = ''
        self.lock = threading.Lock()
        self.bridge = None
        self.log = None
        self.worker = None

    def send(self, address, value):
        self.client.send_message('/session/' + address, value)

    def start_eeg(self, *_):
        if self.bridge is not None and self.bridge.poll() is None:
            return
        # A bound control port means an existing project bridge is already running.
        probe = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            probe.bind(('127.0.0.1', 9001))
        except OSError:
            self.status = 'System ready. Existing EEG bridge is running.'
            return
        finally:
            probe.close()
        self.log = open(ROOT / 'audio/eeg.log', 'a')
        self.bridge = subprocess.Popen([sys.executable, str(ROOT / 'eeg/eeg_bridge.py')],
                                       stdout=self.log, stderr=self.log)

    def job(self, address, *_):
        if not self.lock.acquire(blocking=False):
            self.send('status', 'A FlowEdit job is already running. Please wait.')
            return
        prompts = tuple(str(value).strip() for value in _[:2]) if address.endswith('/generate') and len(_) >= 2 else None
        label = 'A' if address.endswith('/a') else 'B'
        self.worker = threading.Thread(target=self.run, args=(address.endswith('/generate'), prompts, label), daemon=True)
        self.worker.start()

    def caption(self, session, label, data):
        fingerprint = hashlib.sha256(data).hexdigest()
        cached = json.loads(CACHE.read_text()) if CACHE.is_file() else {}
        entry = cached.get('a', {}) if label == 'A' else cached
        if entry.get('sha256') == fingerprint:
            caption = entry['caption']
        else:
            self.status = 'Describing ' + label + ' recording...'
            caption = describe(session, data)
            entry = dict(sha256=fingerprint, caption=caption)
            if label == 'A':
                cached['a'] = entry
            else:
                cached.update(entry)
            CACHE.write_text(json.dumps(cached) + '\n')
        if label == 'A':
            self.prompt_a = caption
            self.send('prompt_a', caption)
        else:
            self.prompt = caption
            self.send('prompt', caption)
        return caption

    def run(self, generate, prompts=None, label='B'):
        try:
            with requests.Session() as session:
                session.headers['Authorization'] = 'Bearer ' + load_key()
                if not generate:
                    data, _ = read_audio(label)
                    self.caption(session, label, data)
                    self.status = label + ' prompt ready. Edit the API prompts, then click Generate Audio.'
                    return
                b, _ = read_audio('B')
                caption = prompts[1] if prompts and prompts[1] else self.caption(session, 'B', b)
                a, info = read_audio('A')
                source = prompts[0] if prompts and prompts[0] else self.caption(session, 'A', a)
                body = dict(src_prompt=source, tar_prompt=caption,
                            audio_b64=base64.b64encode(a).decode(),
                            seconds_total=max(1, min(47, round(info.duration))),
                            lfe_steps=20, n_avg=10, src_lfe_cfg_scale=1.0,
                            tar_lfe_cfg_scale=5.0, num_intermediates=NUM_INTERMEDIATES,
                            even_steps=True, seed=-1)
                self.status = 'Generating FlowEdit audio. Server queue may take up to 45 minutes.'
                result, headers = request(session, '/generate', body, 2700)
            save_sequence(a, b, result, [source, caption], ROOT / 'audio/generated', headers)
            self.status = 'Audio generated. Loading into Max; press START when Audio ready appears.'
            self.send('complete', 1)
        except Exception as error:
            # Display only a safe error class for transport failures; headers remain private.
            self.status = ('Error: ' + str(error)) if isinstance(error, (ValueError, RuntimeError)) else ('Error: ' + type(error).__name__ + '. Check inputs and service availability.')
        finally:
            self.send('status', self.status)
            self.lock.release()

    def close(self):
        if self.bridge is not None and self.bridge.poll() is None:
            self.bridge.terminate()
            self.bridge.wait(timeout=5)
        if self.log:
            self.log.close()
        self.client.close()


def main():
    controller = Controller()
    dispatch = Dispatcher()
    dispatch.map('/session/prompt', controller.job)
    dispatch.map('/session/prompt/a', controller.job)
    dispatch.map('/session/generate', controller.job)
    dispatch.map('/session/eeg', controller.start_eeg)
    try:
        server = OSCUDPServer(('127.0.0.1', 9002), dispatch)
    except OSError:
        print('The Max controller is already running (port 9002).')
        return 0
    server.timeout = 0.1
    controller.start_eeg()
    print('Max controller running. Keep this window open; all controls are in Max.', flush=True)
    last = 0
    try:
        while True:
            server.handle_request()
            if time.monotonic() - last >= 1:
                controller.send('status', controller.status)
                if controller.prompt_a:
                    controller.send('prompt_a', controller.prompt_a)
                if controller.prompt:
                    controller.send('prompt', controller.prompt)
                last = time.monotonic()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
        controller.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
