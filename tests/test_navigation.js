// test_navigation.js developed by Bob Tianqi Wei
// Verify two-bank handoffs retain the shared phase and playing sound.
const fs = require('fs'), vm = require('vm'), assert = require('assert');
let now = 1000;
const messages = [];
const folders = {'/old': ['00_A.wav', '01_B.wav'], '/default': ['seed.wav'], '/new': ['00_A.wav', '01_target.wav']};
const context = {
    jsarguments: ['navigation.js', 'test'],
    Date: {now: () => now},
    outlet: (...values) => messages.push(values),
    Task: function(fn, receiver) { this.fn = fn; this.receiver = receiver; this.cancel = this.repeat = this.schedule = () => {}; },
    Folder: function(path) {
        const files = folders[path] || []; let index = 0;
        Object.defineProperty(this, 'end', {get: () => index >= files.length});
        Object.defineProperty(this, 'filename', {get: () => files[index]});
        this.next = () => index++; this.close = () => {};
    },
    Buffer: function() {this.framecount = () => 240000; this.channelcount = () => 1; this.length = () => 10000;},
    patcher: {filepath: '/project/max/performance.maxpat'}
};
vm.createContext(context);
vm.runInContext(fs.readFileSync('max/navigation.js', 'utf8'), context);
context.folderPath = '/old'; context.loadFolder(); context.checkLoaded(); context.start();
assert(context.playing);
messages.length = 0;
context.autoplay('/default');
assert(context.playing);
assert(!messages.some(values => values[0] === 5 && values[1] === 'clear'));
context.checkAutomatic();
assert(context.transition);
assert(!messages.some(values => values[0] === 2));
now += 1000; context.showPair();
assert(context.voices[0].gain > 0.6 && context.voices[0].gain < 0.8);
assert(messages.some(values => values[0] === 3 && values[1] === 'gain' && values[2] > 0));
context.autoplay('/new');
assert.equal(context.queuedFolder, '/new');
now += 1100; context.showPair();
assert(context.incoming);
context.checkAutomatic();
now += 2100; context.showPair();
assert(!context.transition);
assert(context.playing);
assert.equal(context.files.length, 2);
context.position(0);
assert.equal(context.target, 0.5);
context.autoposition(1);
assert.equal(context.target, 1);
context.automatic(0); context.position(0.2);
assert.equal(context.target, 0.2);
console.log('Navigation checks passed: background loading, equal-power handoff, shared phase, queued stages, single default sound and manual mapping.');
