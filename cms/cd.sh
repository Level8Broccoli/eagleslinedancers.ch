#!/usr/bin/env sh

if [ ! -d /tmp/eagleslinedancers.ch ]; then
  mkdir -p /tmp/eagleslinedancers.ch;
fi

GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git clone git@github.com:Level8Broccoli/eagleslinedancers.ch.git /tmp/eagleslinedancers.ch
ls /tmp/eagleslinedancers.ch
curl -X POST -d '{"username":"GitHub","content":"Testnachricht"}' -H "Content-Type: application/json" https://discord.com/api/webhooks/902909348056035368/h6qTVOqTNYX1_pVb4K0ZXAz_Zn7xYy_srXpH0jpc1UuEPi4Nn4F95ngv7kH2fmkcOfJb
