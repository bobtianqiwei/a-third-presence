// test_performance_recording.js developed by Bob Tianqi Wei
const fs = require('fs'), vm = require('vm'), assert = require('assert');
const messages = [], status = [];
const context = {
    Dict: function() {this.freepeer = () => {};},
    Task: function() {this.cancel = this.schedule = this.repeat = () => {};},
    outlet: (...args) => status.push(args),
    patcher: {getnamed: () => ({message: (...args) => messages.push(args)})}
};
vm.createContext(context);
vm.runInContext(fs.readFileSync('max/session.js', 'utf8'), context);
context.root = '/project/';
context.record_performance();
assert(/^\/project\/audio\/performances\/Performance_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}-\d{3}\.wav$/.test(context.performancePath));
assert.deepEqual(messages[0], ['samptype', 'int24']);
assert.deepEqual(messages[1], ['open', context.performancePath, 'wave']);
context.record_performance();
assert.equal(messages.length, 2);
context.beginPerformance();
assert.deepEqual(messages[2], ['int', 1]);
context.stop_performance();
assert.deepEqual(messages[3], ['int', 0]);
assert(!context.performanceRecording);
assert(status.some(args => args[1] === 'performance' && args[2].startsWith('Saved performance:')));
context.stop_performance();
assert.equal(messages.length, 4);
context.root = '';
context.record_performance();
assert.equal(messages.length, 4);
console.log('Performance recording checks passed: timestamped local paths, 24-bit output, unlimited start/stop, duplicate-click protection and missing-root guard.');
