#!/usr/bin/env sh

cd /tmp

if [ -d eagleslinedancers.ch ]; then
  rm -R eagleslinedancers.ch;
fi

GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git clone git@github.com:Level8Broccoli/eagleslinedancers.ch.git

cd eagleslinedancers.ch

curl \
  -X GET \
  -H "Content-Type: application/json" \
  -o data-seiten.json \
  http://localhost:1337/seiten


if [ ! $(git diff --quiet) ] || [ ! $(git diff --staged --quiet) ]; then
  git commit -am 'fetch new seiten data';
  GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git push;
fi
