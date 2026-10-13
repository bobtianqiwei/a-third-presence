# A Third Presence

## 1. Overview

Two participants wear EEG sensors and jointly navigate a continuously changing sound space. Attention values control an artistic mapping. They are not validated measures of emotion or interpersonal attention.

This prototype uses Python 3.10 or later, Max 8 or 9, and macOS. All interface text is in English. Audio is generated before a performance.

## 2. System Architecture

```text
EEG A + EEG B -> Python EEG Bridge -> OSC -> Max/MSP -> stereo audio
FlowEdit -> offline WAV sequence -> Max/MSP
```

Max uses its built-in JavaScript engine for folder loading and player state. No Node.js or external Max packages are required.

## 3. Hardware

- Two NeuroMate-II EEG devices and two USB receivers.
- A Mac with Python 3 and Max/MSP installed.
- Speakers or headphones connected to the selected Max audio device.

Receivers use 57600 baud and ThinkGear framing. Raw EEG has a nominal rate of 512 Hz; this program does not measure or enforce that rate.

## 4. Check EEG Receivers

```bash
ls /dev/cu.usbmodem*
```

One observed receiver is `/dev/cu.usbmodem6D9336B355891`. The bridge also scans usbserial, SLAB_USBtoUART, and wchusbserial ports. These names identify serial candidates; they do not prove a device is an EEG receiver.

Zero receivers: the bridge stays running and scans every two seconds. One receiver: it runs that participant and waits for a second. Two receivers: sorted port names become A and B. More than two: use the A/B receiver menus in Max. The Terminal lists candidates and continues running. Reconnection retries the assigned port every two seconds. If a receiver returns with a different path, click **Refresh Receivers** and choose the new path in Max.

## 5. Python Setup

Run these commands from the project directory:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

The `.command` launchers also create the environment automatically. They locate the project from their own path, so the current working directory does not matter.

## 6. Install Dependencies

```bash
python -m pip install -r requirements.txt
```

Launchers install dependencies the first time and when requirements change. Later runs reuse the environment. Internet access is needed for the initial installation and audio generation.

## 7. FlowEdit API Setup

The implementation follows the [course notebook](https://github.com/jon-myers/flowedit-notebook/blob/main/flowedit_api.ipynb), checked on October 5, 2026.

Service: `https://audioflow.csail.mit.edu`. Authentication: `Authorization: Bearer <key>`.

- `POST /describe`: JSON containing `audio_b64` and `words: 40`; response field `caption`.
- `POST /generate`: source WAV in `audio_b64`, `src_prompt`, `tar_prompt`, `seconds_total`, `lfe_steps`, `n_avg`, guidance scales, `num_intermediates`, `even_steps`, and `seed`.
- Generation waits in a first-come queue inside the same HTTP request. There is no job polling in this notebook. The read timeout is 2700 seconds.
- The response contains `intermediates` with `label` and `audio_b64`, plus `final.audio_b64` and `seed`. WAV data arrives inline; no download URLs are assumed.
- Snapshots are sorted by descending numeric `t` before the final target. Defaults are nine intermediates and 20 denoising steps, giving twelve WAV files including real A, the AI target, and real B.

The notebook uses `FLOWEDIT_KEY`, which takes precedence over the suggested `FLOWEDIT_API_KEY` name in the project brief. Automatic captions provide the default source and target descriptions. Max lets you edit both API prompts before generating audio.

Inputs must be nonempty mono or stereo WAV files, up to 47 seconds each. The service duration is the rounded duration of A, clamped to 1–47 seconds, as in the notebook. Original A and B remain byte-for-byte copies.

## 8. Set API Key

```bash
export FLOWEDIT_KEY="your-personal-key"
./prepare_audio.command
```

Run generation in the same Terminal session as `export`. Finder launches may not inherit this variable. No key is saved in project files or metadata.

## 9. Add Input Audio

Place your own recordings here:

```text
audio/input/A.wav
audio/input/B.wav
```

These files are intentionally absent from the delivered project. Use short recordings with comfortable levels and quiet or matching loop endpoints. The prototype does not normalize loudness or repair loop seams.

### Record A and B in Max

You can also record the inputs in `max/performance.maxpat`. In Max Audio Status, select your microphone or audio interface and input channel 1. Allow Max microphone access if macOS asks. The **Mic Input** meter should respond when you speak.

Press **Record A**, speak, then press **Stop Recording**. Repeat with **Record B**. The patch records mono 16-bit WAV files directly to the two input paths above. Each recording is limited to 45 seconds. Selecting another participant stops the current recording first. Recording replaces that participant's existing input WAV; generated sequences stay available. Playback fades out when recording starts, and microphone audio is not sent directly to speakers.

Recording enables DSP. Use the DSP control to turn it off afterward if needed. Stop recording before generating audio or starting a performance. If the meter stays silent, check Max Audio Status and macOS microphone permission. File-writing errors appear in the Max Console.

## 10. Generate Audio Sequence

```bash
./prepare_audio.command
```

The script describes A and B, prints both captions, and generates the sequence. Max displays both descriptions from `metadata.json` in the selected audio folder. In Max, use **Generate A Prompt** and **Generate B Prompt** to preview captions, edit **A Prompt** and **B Prompt**, then click **Generate Audio** to send those texts as `src_prompt` and `tar_prompt`. Empty fields use automatic captions. Recording a new input does not change a prompt until you generate it again. Outputs are:

```text
audio/generated/00_A.wav
audio/generated/01_intermediate.wav
...
audio/generated/09_intermediate.wav
audio/generated/10_AI_target.wav
audio/generated/11_B.wav
audio/generated/metadata.json
```

Every WAV is validated before the output folder is replaced. Failed requests or invalid audio leave the previous sequence available. Successful generation replaces the generated folder, including any files manually added there. Keep personal source material in `audio/input`, and back up sequences you want to retain. Stop playback before generating or reloading audio.

The script avoids automatically retrying a generation POST after a timeout, since the server may already be rendering it. Check your FlowEdit History before trying again.

## 11. Open Max Patch

Open `max/performance.maxpat`. Keep `max/navigation.js`, `max/session.js`, and `max/receivers.js` beside it. The default folder is `../audio/generated/`, resolved from the patch's saved location. Use **Choose Audio Folder** if needed, then **Reload Audio** after a new generation.

DSP starts off. The master control defaults to 0.25 and is limited to 0–1. Set a comfortable volume, choose an audio device in Max's Audio Status window, and press **START**. **STOP** fades all tracks to silence. DSP can be turned off with the speaker control.

The interface shows both participants, their assigned EEG receiver paths and connection status, position, current pair, crossfade, actual continuous index, indices, file count, folder, and OSC status. The slider can control position manually when the bridge is stopped. Active OSC updates take over the slider.

## 12. Run EEG Bridge

```bash
./run_eeg.command
```

Each participant has a clickable **EEG Receiver** dropdown in Max. Start the bridge, connect the receivers, and click **Refresh Receivers**. Choose A's serial path in the left menu and B's path in the right menu. The path and status below each menu show Python's confirmed assignment. These text labels are read-only; use the dropdown with the arrow to change devices. Lock the patch (Cmd+E if it is unlocked) to operate the controls.

With at most two candidates, the bridge still assigns available receivers automatically in sorted order as a starting point. With more than two, it waits for your menu choices without blocking in Terminal. Choosing the receiver already assigned to the other participant swaps the assignments, and the old serial readers close before their replacements start. Only participants whose assignments change reset their smoothed EEG state. **Not assigned** releases a participant's receiver and leaves it unassigned until you choose one again. Assignments remain fixed through disconnects; a disconnected path stays visible and is marked in the menu. Choose the new path if a reconnected receiver gets a different name.

Automatic assignment does not identify the person wearing the sensor. Check the paths before the performance. Menus require the bridge to be running. If it is offline or no receivers are found, the interface explains that state. Simulation opens no hardware and rejects receiver selections.

Press Ctrl+C to stop. The Terminal refreshes twice per second; OSC updates run at 20 Hz. Raw EEG never floods the Terminal.

For a clearly labeled synthetic control test without receivers:

```bash
./run_eeg.command --simulate
```

Simulation does not generate audio or emulate a scientific EEG measurement.

## 13. OSC Messages

Destination: `127.0.0.1:9000`.

| Participant A | Participant B | Value |
| --- | --- | --- |
| `/eeg/a/attention` | `/eeg/b/attention` | Smoothed, 0–1 |
| `/eeg/a/meditation` | `/eeg/b/meditation` | Smoothed, 0–1 |
| `/eeg/a/signal` | `/eeg/b/signal` | Raw quality, -1 if unknown |
| `/eeg/a/alpha` | `/eeg/b/alpha` | Low alpha + high alpha |
| `/eeg/a/beta` | `/eeg/b/beta` | Low beta + high beta |
| `/eeg/a/theta` | `/eeg/b/theta` | Raw theta power |

`/eeg/a/device` and `/eeg/b/device` send the assigned serial paths as strings, or `Not assigned` / `SIMULATED (no receiver)`. `/eeg/a/status` and `/eeg/b/status` send connection status strings. These four messages update twice per second. `/eeg/devices` sends the current serial candidate list and `/eeg/control/status` sends selection feedback at the same interval. The assigned path remains visible if its receiver disconnects; the status shows the problem. When OSC is idle, device labels show the last received assignments.

`/sound/position` is always 0–1. Max routes the position and attention, meditation, and signal messages. Other band messages are available for future use. Max's native `udpreceive 9000` decodes these single OSC messages directly, as described in the [official reference](https://docs.cycling74.com/reference/udpreceive/).

Max sends controls to Python at `127.0.0.1:9001` using native `udpsend`. `/eeg/select/a` and `/eeg/select/b` each carry one serial path string, or `Not assigned` to release that participant. `/eeg/refresh` requests a rescan. Run only one EEG bridge so port 9001 is available.

## 14. Attention Mapping

```text
position = attention_B / (attention_A + attention_B)
```

80/20 gives 0.20; 50/50 gives 0.50; 20/80 gives 0.80 before position smoothing. EEG values use a smoothing factor of 0.15; position uses 0.10. These settings and the OSC destination are at the top of `eeg/eeg_bridge.py`.

If either participant lacks recent valid data, or the attention sum is below 10, position moves gradually toward 0.5. Initial attention and meditation displays start at neutral 0.5 until valid values arrive. They are placeholders, not measurements.

## 15. Audio Navigation

Position 0 is real A, 0.5 is the middle of the complete sequence, and 1 is real B. The AI target sits immediately before real B.

All WAV files are sorted numerically and loaded into RAM with `polybuffer~`. Every file has a stereo `play~` reader. A single audio-rate clock supplies the same playback position in milliseconds to every reader, including muted tracks. Mono files are duplicated to both output channels. The readers use the official [play~ signal input](https://docs.cycling74.com/reference/play~/).

The desired index is `position * (N - 1)`. Position changes only gains; readers keep their buffers and shared playback time. At an exact index one track is audible. Between indices, the two neighboring tracks use equal-power crossfading:

```text
left_gain  = cos(crossfade * pi / 2)
right_gain = sin(crossfade * pi / 2)
```

`line~` ramps gains over 50 ms. The continuous index moves at most 0.04 per 20 ms tick, including across interval boundaries. START begins all tracks at time zero; repeated START while playing does not reset the clock. STOP fades all tracks and pauses the clock. Reload fades out before rebuilding the readers.

The common loop lasts as long as the longest file. Shorter recordings are silent after their end until the common loop restarts. Files are played at their original speed without stretching. Synchronizing playheads does not align events that were recorded at different times within the source WAVs.

## 16. Signal Quality

ThinkGear signal 0 means best contact; larger values usually indicate worse contact. New attention and meditation are ignored when signal is unknown, above 50, or older than three seconds. Disconnected or stale attention also makes the joint mapping return toward neutral. Last valid individual values remain visible, so check signal and the Terminal's `Valid` status.

The parser checks synchronization, lengths, checksums, extended codes, signed raw samples, and eight unsigned 24-bit power bands. Raw EEG is retained for debugging and never controls sound.

## 17. Troubleshooting

| Problem | Action |
| --- | --- |
| No EEG receiver found | Plug in receivers; check the port listing and USB cable. The bridge keeps scanning. |
| Only one EEG receiver detected | Connect the second receiver. The available participant continues; joint position stays near neutral. |
| Serial port busy | Close other serial monitors or EEG programs. Reconnection retries every two seconds. |
| Permission denied | Run `chmod +x run_eeg.command prepare_audio.command`. Check receiver permissions if the serial port is denied. |
| FlowEdit API key missing | Export `FLOWEDIT_KEY` and run generation in that Terminal session. |
| FlowEdit request failed | Check the personal key, connection, service health, and History. A timed-out render may still exist remotely. |
| Missing WAV | Add mono/stereo A.wav and B.wav under `audio/input`. |
| No generated audio found | Generate audio, or choose the correct folder. At least two valid WAV files are required. |
| Receiver menu has no devices | Start `run_eeg.command`, connect receivers, and click Refresh Receivers. Use the menu arrow, and lock an unlocked patch with Cmd+E. |
| Receiver selection has no effect | Restart the updated bridge and reopen the updated patch. Check control port 9001 and the confirmation text. |
| Max receives no OSC | Open one copy of the patch. Check port 9000 and start the bridge. The Console should show the UDP binding. |
| No audio output | Generate/load audio, select Max's output device, press START, enable DSP, and raise master volume gently. |
| Clicks at loop boundaries | Edit recording endpoints or add short fades before using them. Independent file loops can have audible seams. |
| Folder loading failed | Check the Max Console, mono/stereo format, file paths, and available RAM. |
| macOS blocks a launcher | Open it through Finder's Open command or run it from Terminal after checking its contents. |

## 18. Project Concept

Attention acts as a relational force in this artwork. Two participants jointly navigate a sound space between their voices. EEG and AI serve as speculative mediators of presence. The system makes no claim to read emotion or measure psychological attention precisely.

## Verification and Limits

Run automated checks from the project directory:

```bash
.venv/bin/python -m unittest discover -s tests -v
```

Tests cover packet framing, checksums, signed raw data, power bands, malformed packets, smoothing, quality gating, mapping, two simultaneous pseudo-terminal serial readers, disconnect behavior, real OSC loopback, mocked describe requests, output ordering, WAV validation, preservation on failure, patch JSON connections, receiver menu routing, selection commands over real OSC, swapping, explicit unassignment, and stale-data reset on a device change.

In the development session, Max loaded four temporary mono/stereo WAV fixtures from the default folder, received synthetic EEG over OSC, navigated adjacent pairs in both directions, enabled DSP with START, and faded output with STOP. The folder chooser opened successfully and the Max Console showed no object errors. Temporary audio was removed afterward. The updated interface also displayed a test B caption read from metadata. Recorder routing, file paths, sequential A/B control, the 45-second limit, and missing/malformed metadata handling passed logic checks. Actual microphone recording and recorded WAV output were not verified because subsequent Max UI automation timed out.

The receiver menus appeared in the actual Max interface and populated with the detected `/dev/cu.usbmodem6D9336B355891` path. The bridge reported that receiver connected under Participant A; a valid Attention measurement was not confirmed. Automated tests verified OSC-driven reassignment with two real pseudo-terminal serial readers, and menu logic verified silent confirmations, refresh commands, disconnected labels, and offline handling.

Physical NeuroMate-II behavior, authenticated live FlowEdit generation, and audible performance quality require a real session. Synthetic serial and audio fixtures do not prove those results. All readers share one timeline; unequal file lengths leave silent tails, and unequal levels can affect the perceived crossfade. Equal-power mixing can raise peaks for correlated recordings; prepare comfortable audio levels. This prototype uses a RAM bank and supports one performance patch at a time on port 9000.

## Max button workflow

Open `max/performance.maxpat` and click **Start System**. This opens the local `start_system.command` launcher in Terminal. Keep that window open; no Terminal commands are needed. The controller uses localhost OSC port 9002 and reuses an EEG bridge already listening on port 9001.

1. Choose the A and B receivers in their menus.
2. Select the microphone in Max Audio Status. Click Record A, then Stop Recording. Repeat with Record B.
3. Click Generate A Prompt and Generate B Prompt to preview both recording descriptions.
4. Edit A Prompt and B Prompt as needed, then click Generate Audio. Each prompt appears once, in its editable field. Max reads both fields at that click and sends them as `src_prompt` and `tar_prompt`. Empty fields use automatic descriptions. Repeated backend status updates preserve your edits. Edits are saved locally every two seconds in `audio/prompt-edits.json` and restored when the patch opens; this file is ignored by Git.
5. Wait for Audio ready, then click START. Generated audio loads automatically.

Recordings use absolute project paths: `audio/input/A.wav` and `audio/input/B.wav`. The full recording destination appears at the bottom of the interface. A new recording replaces the corresponding input. No generated files means START cannot play yet; the interface explains the required preparation.

The local key is read from `~/Library/Application Support/A Third Presence/flowedit.key` (permissions 600), or from `FLOWEDIT_KEY` if supplied. The key file is outside this repository. Never copy it into source files. Prompt cache, recordings, generated audio, and local logs are ignored by Git.

## Automatic EEG Sessions

Open `max/performance.maxpat`. Max starts the local controller automatically; keep its Terminal window open. The normal participant flow needs no recordings or typed prompts. **Automatic** is enabled by default. Select receivers once if the machine has ambiguous serial devices; the existing receiver menus remain available.

The existing signal-quality and fresh Attention checks gate detection. Automatic sessions additionally require fresh Meditation data, two seconds of stable contact, and fresh telemetry from the bridge. USB connection alone does not start a session. After the first stable EEG, collect ten seconds of valid Attention and Meditation samples. A participant must remain stable at the deadline and contribute at least two seconds of samples. Both eligible participants select Duo; one selects Solo A or Solo B. Only valid samples contribute to their means. Short dropouts do not cause another generation. The mode is fixed for that session. Eight seconds without a valid EEG from the current session ends it and saves an available final sound; wearing EEG again starts a new session.

Duo makes two sequential FlowEdit requests: default → A, then A → B. Both stages retain all nine intermediate snapshots and their final sounds. The final interactive sequence has eleven sounds: A, nine intermediates, B. The final B sound is generated from B's mapped prompt. Solo uses the last completed participant sound as its source, or the default when no history exists, and retains the same eleven-state sequence. Solo position covers the full range: low Attention stays near the inherited source, high Attention approaches the current participant. Duo retains `attention_B / (attention_A + attention_B)`, with smoothing and a neutral fallback for a zero sum. Manual mode retains the original EEG position mapping.

The prompt rules in `flowedit/automatic.py` use a configurable midpoint of 0.5. High Attention gives clear rhythmic structure; low Attention gives diffuse abstract structure. High Meditation gives soft sustained tones; low Meditation gives rough restless textures. These are artistic sound mappings and do not identify emotion, personality, or mental health.

The generation worker shares the existing FlowEdit job lock and does not block EEG readers or OSC handling. Max plays the default during capture and can play the inherited source during Solo generation. Two playback banks load incoming sounds without clearing the audible bank, retain the shared phase, and crossfade over two seconds. Every sound in a sequence continues reading the shared timeline; position changes gains. The API provides queue/render completion rather than live percentage progress, so Max and Terminal display stages and waiting status.

**Reset / New Session** saves the current completed participant sound, invalidates unfinished results, and starts a new detection cycle. It does not cancel an already submitted request on the remote server; the next generation waits for that request to return. Removing both headsets pauses new requests immediately and ends the session after the absence grace period. Results from ended sessions do not start playback. An API error shows an English error state; use New Session to retry. Missing or stale Meditation prevents automatic capture rather than inventing that measurement.

Manual recording and prompt generation remain available and turn Automatic off. The Automatic toggle or New Session restores automatic detection. The original recording inputs and `audio/generated` sequence remain separate. New immutable sequences live under `audio/sessions`; `audio/history.json` points to the last completed sound after session end. Both are local and ignored by Git. The existing private API-key location is unchanged.

Validation: `python -m unittest discover -s tests` covers the state machine, mocked two-stage API generation, actual WAV output, history inheritance, reset isolation, signal validity, existing manual generation, and local OSC/serial behavior. `node tests/test_navigation.js` checks background buffer loading, equal-power handoff, shared-phase preservation, single-source playback, queued stages, and manual position control. Real headset contact, FlowEdit queue/render behavior, and audible handoffs through the selected Max audio device require hardware/service testing.

## Record a Performance

In Max, click **Record Performance** to record the final stereo output after Master Volume, including both playback banks during transitions. Click **Stop Performance Recording** to finish and close the WAV file. The microphone is not added unless it is routed into the output. Playback controls remain independent of the recording controls; STOP can therefore record silence until recording is stopped.

Files are saved locally in `audio/performances`, for example `Performance_2026-10-13_14-35-20-123.wav`. The date and time use the computer's local clock; milliseconds distinguish rapid takes. Recordings use 24-bit PCM at Max's current sample rate and are ignored by Git. Closing the patch finishes an active recording. Run `node tests/test_performance_recording.js` to verify control and filename logic. Actual WAV capture and audible content require Max playback verification.
