#!/usr/bin/env sh

if [ ! -d /tmp/eagleslinedancers.ch ]; then
  mkdir -p /tmp/eagleslinedancers.ch;
fi

GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git clone git@github.com:Level8Broccoli/eagleslinedancers.ch.git /tmp/eagleslinedancers.ch
ls /tmp/eagleslinedancers.ch
curl \
  -X GET \
  -H "Content-Type: application/json" \
  -o /tmp/eagleslinedancers.ch/data-seiten.json \
  http://localhost:1337/seiten
git diff --quiet && git diff --staged --quiet || git commit -am 'fetch new seiten data' && GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git push
