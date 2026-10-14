# A Third Presence

An interactive sound prototype for one or two participants wearing EEG sensors. The first ten seconds of valid Attention and Meditation data shape English sound prompts. FlowEdit transforms an existing sound using those prompts, and live Attention controls movement through the resulting sound sequence.

These are artistic mappings. The project does not identify emotions or measure psychological attention precisely.

```text
EEG → Python → sound prompts → FlowEdit → WAV sequences
         └── live Attention → OSC → Max/MSP → stereo output
```

## Requirements and setup

- macOS, Python 3.10 or later, and Max 8 or 9.
- One or two NeuroMate-II EEG devices with USB receivers.
- Headphones or speakers connected to Max's selected audio output.
- Internet access for initial dependency installation and FlowEdit generation.

The launchers create a local `.venv` and install `requirements.txt` automatically. Max uses built-in objects and JavaScript; no external Max packages or Node.js runtime are required for playback.

Store your FlowEdit key in this local file:

```text
~/Library/Application Support/A Third Presence/flowedit.key
```

The file should contain only the key and have permissions `600`. Keep it outside the repository. For Terminal launches, `FLOWEDIT_KEY` can also supply the key and takes precedence. The API integration follows the [course notebook](https://github.com/jon-myers/flowedit-notebook/blob/main/flowedit_api.ipynb).

## Automatic workflow

1. Open `max/performance.maxpat`. It starts the local controller automatically. Keep its Terminal window open; **Start System** launches it if needed.
2. Select your output device in Max's **Audio Status** and set a comfortable volume.
3. Check the A/B receiver menus. With up to two serial candidates, receivers are assigned automatically by sorted port name. Use **Refresh Receivers** and the menus to correct assignments; automatic assignment cannot identify who wears each headset.
4. Leave **Automatic** enabled and put on the EEG sensors. After two seconds of stable valid data, the system collects ten seconds of Attention and Meditation.
5. Sound generation runs in the background. Max displays the mode, countdown, generation stage, and sound position, then starts interaction automatically.

Detection uses signal quality and recent Attention and Meditation data. USB connection alone cannot start a session. Each participant needs at least two seconds of valid samples and stable data at the end of capture. Short signal dropouts do not restart generation; the session mode stays fixed until it ends.

| Mode | Sound generation | Live interaction |
| --- | --- | --- |
| Duo | Default sound → A, then A → B | Higher A Attention moves toward A; higher B moves toward B. Similar values place the sound near the middle. |
| Solo A / Solo B | Previous participant's completed sound → current participant; default sound if no history exists | Low Attention stays near the inherited sound; high Attention moves toward the current participant's sound. |

Duo uses `position = attention_B / (attention_A + attention_B)` when the sum is positive. Automatic Solo uses the current participant's Attention over the full inherited-to-current range. Position changes are smoothed.

Prompt rules use the ten-second averages and a configurable threshold of `0.5` in `flowedit/automatic.py`:

| EEG indicator | Below 0.5 | At or above 0.5 |
| --- | --- | --- |
| Attention | Diffuse, scattered, abstract | Clear, rhythmic, structured |
| Meditation | Rough, unstable, restless | Soft, smooth, sustained |

Each FlowEdit stage saves its source, nine intermediate sounds, and the generated target. Max reads all sounds on a shared playback timeline and crossfades between neighboring states. Incoming sequences load into a second bank and fade in over two seconds. FlowEdit provides completed results rather than live percentage progress; the interface shows stages and waiting status.

**New Session** saves an available completed sound and starts a new detection cycle. Eight seconds without valid EEG from the current session also ends it. Reset discards unfinished results locally; an already submitted API request continues remotely, and the next request waits for it to return.

## Manual recording and prompts

Manual controls turn Automatic off. Enable **Automatic** or click **New Session** to return to automatic detection.

1. Select microphone input channel 1 in Max Audio Status. Check that **Mic Input** responds.
2. Click **Record A** or **Record B**, then **Stop Recording**. Each recording replaces that participant's input WAV and is limited to 45 seconds.
3. Click **Generate Prompt** beside **A Prompt** or **B Prompt**. Edit the text, then click **Generate Audio**. Empty fields use generated audio descriptions. Prompt edits save locally every two seconds.
4. Wait for the generated sequence to load, then click **START**. **STOP** fades playback to silence. Use **Choose Audio Folder** and **Reload Audio** for another sequence.

Manual generation transforms the A recording using the B prompt and includes the original B recording as the final playback state. The AI target is a generated sound. Source files must be nonempty mono or stereo WAVs, up to 47 seconds long. Successful manual generation replaces `audio/generated`; keep copies of sequences you want to retain.

## Record the performance

Click **Record Performance**, then **Stop Performance** to finish a stereo WAV recording of Max's output after the Volume control. Playback and recording controls operate independently; stopping playback can record silence until you stop recording.

Files use the computer's local date and time, for example:

```text
audio/performances/Performance_2026-10-13_14-35-20-123.wav
```

Recordings use 24-bit PCM at Max's current sample rate.

## Local files and troubleshooting

| Location | Contents |
| --- | --- |
| `audio/default/seed.wav` | Built-in starting sound |
| `audio/input/A.wav`, `B.wav` | Manual recordings |
| `audio/generated/` | Latest manual sequence |
| `audio/sessions/` | Automatic session sequences |
| `audio/history.json` | Last completed sound for Solo inheritance |
| `audio/prompt-edits.json` | Saved editable prompts |
| `audio/performances/` | Performance recordings |

Personal recordings, generated sounds, history, prompt edits, and local logs are ignored by Git.

- **No EEG:** click Refresh Receivers, check assignments and sensor contact. Another serial program may be using the receiver. Initial `0.5` values are placeholders; check signal and connection status.
- **Buttons do not respond:** lock an unlocked patch with **Cmd+E**. Confirm the controller is running.
- **No sound:** check the audio output device, Audio control, Volume, and whether audio has loaded. Manual playback needs a prepared sequence.
- **Generation fails:** check the local key and internet connection, then use New Session to retry. A timed-out request may still be rendering; check FlowEdit History before resubmitting.
- **Silent microphone:** check input channel 1 and macOS microphone permission. File errors appear in the Max Console.

Run one performance patch and one EEG bridge at a time. Local OSC uses ports `9000` for Max, `9001` for receiver controls, and `9002` for the controller. Terminal alternatives are `./start_system.command`, `./run_eeg.command`, and `./prepare_audio.command`.

Automated checks cover EEG parsing, signal gating, session logic, mocked API generation, and playback/recording controls. Run `.venv/bin/python -m unittest discover -s tests`, `node tests/test_navigation.js`, and `node tests/test_performance_recording.js` to check them. Real headset contact, authenticated FlowEdit generation, and audible output still require a hardware and service session. Shared playback timing does not align events within recordings; shorter files can leave silent tails, and loop seams or unequal levels may be audible.
