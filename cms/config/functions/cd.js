'use strict';

const { execFile } = require('child_process');

module.exports = async () => {
    if (process.env.NODE_ENV !== 'development') {
        execFile('./cd.sh', (error, stdout, stderr) => {
            if (error) {
                throw error;
            }
            console.log(stdout);
            console.error(stderr);
        });
    }
};
