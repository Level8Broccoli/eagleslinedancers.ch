'use strict';

const { execFile } = require('child_process');

module.exports = async () => {
    execFile('./cd.sh', (error, stdout, stderr) => {
        if (error) {
            throw error;
        }
        console.log(stdout);
        console.error(stderr);
    });
};
