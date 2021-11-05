#!/usr/bin/env sh


if [ -d /tmp/eagleslinedancers.ch ]; then
  rm -R /tmp/eagleslinedancers.ch
fi
mkdir -p /tmp/eagleslinedancers.ch;

GIT_SSH_COMMAND='ssh -i /tmp/.ssh/id_rsa' git clone git@github.com:Level8Broccoli/eagleslinedancers.ch.git /tmp/eagleslinedancers.ch
echo "after clone"
ls /tmp/eagleslinedancers.ch
echo "before curl"
curl \
  -X GET \
  -H "Content-Type: application/json" \
  -o /tmp/eagleslinedancers.ch/data-seiten.json \
  http://localhost:1337/seiten
echo "after curl"
git diff --quiet && git diff --staged --quiet || git commit -am 'fetch new seiten data' && git push
echo "after push"

rm -R /tmp/eagleslinedancers.ch
