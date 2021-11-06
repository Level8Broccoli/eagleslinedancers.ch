#!/usr/bin/env sh

TEMP_FOLDER="/tmp"
GIT_NAME="eagleslinedancers.ch"
SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i ${TEMP_FOLDER}/.ssh/id_rsa"
TYPES="seiten startseite"

cd $TEMP_FOLDER

if [ -d $GIT_NAME ]
then
  rm -R $GIT_NAME
fi

GIT_SSH_COMMAND="${SSH_COMMAND}" git clone git@github.com:Level8Broccoli/${GIT_NAME}.git

cd $GIT_NAME

for TYPE in $TYPES
do
  curl \
    -X GET \
    -H "Content-Type: application/json" \
    -o data-$TYPE.json \
    http://localhost:1337/$TYPE
done

if [ ! $(git diff --quiet) ] || [ ! $(git diff --staged --quiet) ]
then
  git config --global user.name "GitHub Action"
  git config --global user.email "7040739+Level8Broccoli@users.noreply.github.com"
  git add .
  git commit -m 'fetch new seiten data'
  GIT_SSH_COMMAND="${SSH_COMMAND}" git push
fi
