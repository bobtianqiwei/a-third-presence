// session.js developed by Bob Tianqi Wei
// Record mono microphone input and display the generated sequence's B caption.
autowatch = 1;
inlets = 1;
outlets = 6;
var backendSeen = 0, livePrompt = false;
var root = '', generatedFolder = '', recording = '', previousPrompt = null;
var refreshTask = new Task(refreshPrompt, this);
var recordingTask = new Task(stoprecord, this);
var recordStartTask = new Task(beginRecording, this);

function display(name, value) { outlet(2, name, value); }
function projectRoot(path) {
    path = String(path || '').replace(/\\/g, '/');
    var colon = path.indexOf(':');
    if (colon >= 0) path = '/Volumes/' + path.slice(0, colon) + path.slice(colon + 1);
    path = path.replace(/\/[^\/]*\.maxpat$/, '').replace(/\/$/, '');
    if (!/\/max$/.test(path)) return '';
    return path.slice(0, -3);
}
function loadbang() {
    root = projectRoot(this.patcher.filepath);
    generatedFolder = root + 'audio/generated/';
    display('recording', 'Ready. Select the microphone in Max Audio Status.');
    display('prompt', 'Record B, stop recording, then click Generate B Prompt.');
    refreshPrompt();
    refreshTask.interval = 2000;
    refreshTask.repeat();
}
function folder(path) {
    generatedFolder = String(path);
    previousPrompt = null;
    refreshPrompt();
}
function refreshPrompt() {
    if (livePrompt) return;
    var file = new File(generatedFolder.replace(/\/$/, '') + '/metadata.json', 'read');
    var prompt = 'Record B, stop recording, then click Generate B Prompt.';
    if (file.isopen) {
        try {
            var text = '';
            while (file.position < file.eof) text += file.readstring(4096);
            var metadata = JSON.parse(text);
            if (typeof metadata.participant_b_description === 'string')
                prompt = metadata.participant_b_description;
        } catch (error) {
            prompt = 'Could not read the generated B prompt. Check metadata.json.';
        }
        file.close();
    }
    if (prompt !== previousPrompt) {
        display('prompt', prompt);
        previousPrompt = prompt;
    }
}
function record(label) {
    label = String(label).toUpperCase();
    if (label !== 'A' && label !== 'B') return;
    if (!root || root.charAt(0) !== '/') { display('recording', 'Recording disabled: reopen the saved project patch.'); return; }
    stoprecord();
    // Fade playback before opening the microphone recording.
    outlet(3, 'stop');
    display('dsp', 1);
    recording = label;
    display('recording', 'Preparing Participant ' + label + ' recording...');
    recordStartTask.schedule(150);
}
function beginRecording() {
    if (!recording) return;
    var player = recording === 'A' ? 0 : 1;
    outlet(player, 'samptype', 'int16');
    outlet(player, 'open', root + 'audio/input/' + recording + '.wav', 'wave');
    display('recordpath', root + 'audio/input/' + recording + '.wav');
    // Native sample-time limiting also works if the JS scheduler is delayed.
    outlet(player, 'record', 45000);
    display('recording', 'Recording ' + recording + '. Speak into input 1. Stop Recording saves the WAV (45 s maximum).');
    recordingTask.schedule(45100);
}
function stoprecord() {
    recordingTask.cancel();
    recordStartTask.cancel();
    if (recording) {
        outlet(recording === 'A' ? 0 : 1, 0);
        display('recording', 'Saved recording: ' + root + 'audio/input/' + recording + '.wav');
        recording = '';
    }
}
function notifydeleted() {
    stoprecord();
    refreshTask.cancel();
}

function system() {
    var path = root;
    var colon = path.indexOf(':');
    if (colon >= 0) path = '/Volumes/' + path.slice(0, colon) + path.slice(colon + 1);
    if (Date.now() - backendSeen < 3000) {
        outlet(4, '/session/eeg', 1);
        return;
    }
    outlet(5, 'file://' + encodeURI(path + 'start_system.command'));
    display('backend', 'Starting local Python system. Keep its Terminal window open.');
}
function backendstatus() {
    backendSeen = Date.now();
    display('backend', arrayfromargs(arguments).join(' '));
}
function backendprompt() {
    livePrompt = true;
    display('prompt', arrayfromargs(arguments).join(' '));
}
function complete() { outlet(3, 'reload'); }
function generate(kind) {
    if (recording) {
        display('backend', 'Click Stop Recording before generating.');
        return;
    }
    if (Date.now() - backendSeen > 3000) {
        display('backend', 'Click Start System first, wait for System ready, then try again.');
        return;
    }
    outlet(4, kind === 'prompt' ? '/session/prompt' : '/session/generate', 1);
    display('backend', 'Request sent. Waiting for FlowEdit...');
}

function bang() { loadbang(); }
