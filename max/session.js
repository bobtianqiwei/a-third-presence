// session.js developed by Bob Tianqi Wei
// Record mono microphone input and edit source and target API prompts.
autowatch = 1;
inlets = 1;
outlets = 6;
var backendSeen = 0, livePrompt = false;
var captions = {a: '', b: ''}, drafts = {a: '', b: ''};
var promptText = new Dict();
var root = '', generatedFolder = '', recording = '';
var savedPrompts = '';
var refreshTask = new Task(refreshAndSave, this);
var recordingTask = new Task(stoprecord, this);
var recordStartTask = new Task(beginRecording, this);
var initializeTask = new Task(loadbang, this);
initializeTask.schedule(100);

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
    initializeTask.cancel();
    refreshTask.cancel();
    root = projectRoot(this.patcher.filepath);
    generatedFolder = root + 'audio/generated/';
    display('recording', 'Ready. Select the microphone in Max Audio Status.');
    restorePrompts();
    refreshPrompt();
    refreshTask.interval = 2000;
    refreshTask.repeat();
}
function folder(path) {
    generatedFolder = String(path);
    refreshPrompt();
}
function refreshPrompt() {
    if (livePrompt) return;
    var file = new File(generatedFolder.replace(/\/$/, '') + '/metadata.json', 'read');
    if (!file.isopen) return;
    try {
        var text = '';
        while (file.position < file.eof) text += file.readstring(4096);
        var metadata = JSON.parse(text);
        if (typeof metadata.participant_a_description === 'string')
            receivePrompt('a', metadata.participant_a_description);
        if (typeof metadata.participant_b_description === 'string')
            receivePrompt('b', metadata.participant_b_description);
    } catch (error) {
        display('backend', 'Could not read prompt metadata.');
    }
    file.close();
}
function restorePrompts() {
    var file = new File(root + 'audio/prompt-edits.json', 'read');
    if (!file.isopen) return;
    try {
        var text = '';
        while (file.position < file.eof) text += file.readstring(4096);
        var saved = JSON.parse(text);
        for (var i = 0; i < 2; i++) {
            var label = i === 0 ? 'a' : 'b';
            if (typeof saved.drafts[label] !== 'string') continue;
            captions[label] = saved.captions[label];
            drafts[label] = saved.drafts[label];
            setEditor(label, drafts[label]);
        }
        savedPrompts = JSON.stringify({captions: captions, drafts: drafts});
    } catch (error) {
        display('backend', 'Could not restore saved prompts.');
    }
    file.close();
}
function refreshAndSave() {
    refreshPrompt();
    savePrompts();
}
function savePrompts() {
    if (!root) return;
    readEditors();
    var text = JSON.stringify({captions: captions, drafts: drafts});
    if (text === savedPrompts) return;
    var file = new File(root + 'audio/prompt-edits.json', 'write', 'TEXT');
    if (!file.isopen) { display('backend', 'Could not save prompt edits.'); return; }
    file.eof = 0;
    file.writestring(text);
    file.close();
    savedPrompts = text;
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
    savePrompts();
    initializeTask.cancel();
    stoprecord();
    refreshTask.cancel();
    promptText.freepeer();
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
function receivePrompt(label, text) {
    if (captions[label] === text) return;
    captions[label] = text;
    drafts[label] = text;
    setEditor(label, text);
}
function setEditor(label, text) {
    // Dictionary text avoids adding Max atom quotes to multiword prompts.
    promptText.set('text', text);
    promptText.set('mode', 'set');
    this.patcher.getnamed('api_prompt_' + label).message('dictionary', promptText.name);
}
function backendprompt() {
    livePrompt = true;
    receivePrompt('b', arrayfromargs(arguments).join(' '));
}
function backendprompta() {
    livePrompt = true;
    receivePrompt('a', arrayfromargs(arguments).join(' '));
}
function readEditors() {
    for (var i = 0; i < 2; i++) {
        var label = i === 0 ? 'a' : 'b';
        var value = this.patcher.getnamed('api_prompt_' + label).getvalueof();
        drafts[label] = value instanceof Array ? value.join(' ') : String(value || '');
    }
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
    if (kind === 'audio') {
        readEditors();
        outlet(4, '/session/generate', drafts.a, drafts.b);
    } else {
        outlet(4, kind === 'prompta' ? '/session/prompt/a' : '/session/prompt', 1);
    }
    display('backend', 'Request sent. Waiting for FlowEdit...');
}

function bang() { loadbang(); }
