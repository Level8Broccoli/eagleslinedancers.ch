'use strict';

const axios = require('axios');

module.exports = async () => {
    const host = "https://api.github.com";
    const owner = "Level8Broccoli";
    const repo = "eagleslinedancers.ch";
    const url = `${host}/repos/${owner}/${repo}/dispatches`;
    const eventType = "fetch";

    try {
        await axios({
            method: "post",
            url,
            data: { "event_type": eventType },
            headers: { "Accept": "application/vnd.github.v3+json", "Content-Type": "application/json" },
            auth: {
                username: process.env.GH_USERNAME,
                password: process.env.GH_PASSWORD,
            }
        });
    } catch (error) {
        console.log({ error });
    }
};
