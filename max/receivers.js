// receivers.js developed by Bob Tianqi Wei
// Menu commands travel to Python; acknowledged assignments set menus silently.
autowatch = 1;
inlets = 1;
outlets = 4;
var available = [], assigned = ['', ''], options = [''];
var lastUpdate = 0, feedback = '', lastMenu = '';
var statusTask = new Task(showStatus, this);

function loadbang() {
    rebuild();
    showStatus();
    statusTask.interval = 1000;
    statusTask.repeat();
}
function rebuild() {
    options = [''].concat(available);
    for (var i = 0; i < 2; i++) {
        if (assigned[i] && options.indexOf(assigned[i]) < 0) options.push(assigned[i]);
    }
    var key = JSON.stringify(options) + JSON.stringify(available);
    if (key !== lastMenu) {
        for (var player = 0; player < 2; player++) {
            outlet(player, 'clear');
            outlet(player, 'append', 'Not assigned');
            for (var j = 1; j < options.length; j++)
                outlet(player, 'append', options[j] + (available.indexOf(options[j]) < 0 ? ' (disconnected)' : ''));
        }
        lastMenu = key;
    }
    for (var player = 0; player < 2; player++)
        outlet(player, 'set', Math.max(0, options.indexOf(assigned[player])));
}
function devices() {
    available = Array.prototype.slice.call(arguments).filter(function(p) {
        return typeof p === 'string' && p.indexOf('/dev/') === 0;
    });
    lastUpdate = Date.now();
    rebuild();
    showStatus();
}
function assigneda(port) { acknowledge(0, port); }
function assignedb(port) { acknowledge(1, port); }
function acknowledge(player, port) {
    assigned[player] = typeof port === 'string' && port.indexOf('/dev/') === 0 ? port : '';
    rebuild();
}
function choosea(index) { choose(0, index); }
function chooseb(index) { choose(1, index); }
function choose(player, index) {
    if (!lastUpdate || Date.now() - lastUpdate > 3000) {
        feedback = 'EEG bridge is not responding. Run run_eeg.command.';
        showStatus(); rebuild(); return;
    }
    if (index < 0 || index >= options.length) return;
    outlet(2, player === 0 ? '/eeg/select/a' : '/eeg/select/b', options[index] || 'Not assigned');
    feedback = 'Selection sent. Waiting for Python confirmation.';
    showStatus();
}
function refresh() {
    outlet(2, '/eeg/refresh', 1);
    feedback = 'Refresh requested. Run run_eeg.command if the bridge is offline.';
    showStatus();
}
function controlstatus() {
    feedback = Array.prototype.slice.call(arguments).join(' ');
    showStatus();
}
function showStatus() {
    var text = !lastUpdate || Date.now() - lastUpdate > 3000 ?
        'EEG bridge offline. Run run_eeg.command.' :
        (available.length ? feedback || 'Choose a receiver for each participant.' :
         'No receivers detected. Plug in receivers and click Refresh Receivers.');
    outlet(3, 'set', text);
}
function notifydeleted() { statusTask.cancel(); }
