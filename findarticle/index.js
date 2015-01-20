'use strict';

var config = require('./config.json');
var cluster = require('cluster');

try {
    process.setgid('nogroup');
    process.setuid('nobody');
} catch (E) {
    console.log('Failed giving up root privileges');
}

if (cluster.isMaster) {
    for (var i = 0; i < config.workers; i++) {
        cluster.fork();
    }

    cluster.on('exit', function(worker) {
        console.log('worker ' + worker.process.pid + ' died');
        cluster.fork();
    });

} else {
    console.log('Starting worker ' + process.pid);
    require('./finder');
}