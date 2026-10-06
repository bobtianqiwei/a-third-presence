// navigation.js developed by Bob Tianqi Wei
// Every play~ reader uses the same audio-rate timeline; position changes only gains.
autowatch = 1;
inlets = 1;
outlets = 7;
var files = [], channels = [], lengths = [], folderPath = '', ready = false;
var target = 0.5, current = 0, voices = [], duration = 0;
var playing = false, lastOSC = 0;
var bank = 'third_' + jsarguments[1];
var ticker = new Task(tick, this);
var loadTask = new Task(checkLoaded, this);
var reloadTask = new Task(loadFolder, this);
var loadAttempts = 0, pendingStart = false;

function display(name, value) { outlet(4, name, value); }
function voiceMessage(index, name, value) {
    outlet(3, 'target', index + 1);
    outlet(3, name, value);
}
function clearVoices() { voices = []; }
function buildVoices() {
    voices = [];
    outlet(3, 'voices', files.length);
    for (var i = 0; i < files.length; i++) {
        voiceMessage(i, 'setbuf', bank + '.' + (i + 1));
        voiceMessage(i, 'mono', channels[i] === 1 ? 1 : 0);
        voiceMessage(i, 'duration', lengths[i]);
        voiceMessage(i, 'gain', 0);
        voices.push({gain: 0});
    }
    outlet(1, duration);
    outlet(2, 0);
}
function muteVoices() {
    for (var i = 0; i < voices.length; i++) {
        voiceMessage(i, 'gain', 0);
        voices[i].gain = 0;
    }
}
function projectRoot(path) {
    path = String(path || '').replace(/\\/g, '/');
    var colon = path.indexOf(':');
    if (colon >= 0) path = '/Volumes/' + path.slice(0, colon) + path.slice(colon + 1);
    path = path.replace(/\/[^\/]*\.maxpat$/, '').replace(/\/$/, '');
    if (!/\/max$/.test(path)) return '';
    return path.slice(0, -3);
}
function loadbang() {
    folderPath = projectRoot(this.patcher.filepath) + 'audio/generated/';
    display('folder', folderPath);
    display('status', 'Waiting for OSC');
    display('master', 0.25);
    display('position', target);
    ticker.interval = 20;
    ticker.repeat();
    reload();
}
function folder(path) { folderPath = String(path); display('folder', folderPath); reload(); }
function reload() {
    stop();
    ready = false;
    loadTask.cancel();
    reloadTask.cancel();
    // Wait for the gain ramps before clearing any buffers.
    reloadTask.schedule(150);
}
function loadFolder() {
    clearVoices();
    outlet(5, 'clear');
    files = [];
    var f = new Folder(folderPath);
    while (!f.end) {
        if (/\.wav$/i.test(f.filename)) files.push(f.filename);
        f.next();
    }
    f.close();
    files.sort(function(a, b) {
        var na = parseInt(a, 10), nb = parseInt(b, 10);
        if (!isNaN(na) && !isNaN(nb) && na !== nb) return na - nb;
        return a < b ? -1 : (a > b ? 1 : 0);
    });
    display('count', files.length);
    if (files.length < 2) {
        display('audio', 'No audio yet. Record A/B, generate B prompt, then Generate Audio.');
        return;
    }
    for (var i = 0; i < files.length; i++)
        outlet(5, 'append', folderPath.replace(/\/$/, '') + '/' + files[i]);
    loadAttempts = 0;
    loadTask.schedule(100);
}
function checkLoaded() {
    channels = [];
    lengths = [];
    duration = 0;
    for (var i = 0; i < files.length; i++) {
        var b = new Buffer(bank + '.' + (i + 1));
        if (b.framecount() <= 0) {
            if (++loadAttempts < 300) loadTask.schedule(100);
            else display('audio', 'Audio loading failed. Inspect the Max Console.');
            return;
        }
        if (b.channelcount() < 1 || b.channelcount() > 2) {
            display('audio', 'Only mono or stereo WAV files are supported.');
            return;
        }
        channels.push(b.channelcount());
        lengths.push(b.length());
        duration = Math.max(duration, b.length());
    }
    ready = true;
    current = target * (files.length - 1);
    buildVoices();
    display('audio', 'Audio ready. Press START.');
    showPair();
    if (pendingStart) { pendingStart = false; start(); }
}
function position(value) {
    target = Math.max(0, Math.min(1, value));
    display('position', target);
    lastOSC = Date.now();
}
function manual(value) { target = Math.max(0, Math.min(1, value)); display('position', target); }
function start() {
    if (!ready) { pendingStart = true; reload(); display('audio', 'Loading audio. If no files exist, record A/B and click Generate Audio first.'); return; }
    if (!playing) { outlet(2, 0); outlet(0, 1000 / duration); }
    playing = true;
    showPair();
    display('dsp', 1);
    display('transport', 1);
    display('audio', 'Playing');
}
function stop() {
    playing = false;
    outlet(0, 0);
    muteVoices();
    display('transport', 0);
    display('audio', 'Stopped');
}
function showPair() {
    var left = Math.min(files.length - 2, Math.floor(current));
    var right = left + 1;
    var x = Math.max(0, Math.min(1, current - left));
    display('continuous', current);
    display('left', left);
    display('right', right);
    display('crossfade', x);
    display('pair', ('0' + left).slice(-2) + ' <-> ' + ('0' + right).slice(-2));
    for (var i = 0; i < voices.length; i++) {
        var value = !playing ? 0 : (i === left ? Math.cos(x * Math.PI / 2) :
                    (i === right ? Math.sin(x * Math.PI / 2) : 0));
        if (Math.abs(value - voices[i].gain) > 0.000001) {
            voiceMessage(i, 'gain', value);
            voices[i].gain = value;
        }
    }
}
function tick() {
    display('status', lastOSC && Date.now() - lastOSC < 3000 ? 'OSC receiving' : 'OSC idle / no recent position');
    if (!ready) return;
    var desired = target * (files.length - 1);
    current += Math.max(-0.04, Math.min(0.04, desired - current));
    showPair();
}
function notifydeleted() {
    ticker.cancel(); loadTask.cancel(); reloadTask.cancel();
    clearVoices();
}

function bang() { loadbang(); }
