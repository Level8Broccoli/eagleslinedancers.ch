#!/usr/bin/env sh

TEMP_FOLDER="/tmp"
GIT_NAME="eagleslinedancers.ch"
TYPES="seiten startseite fussnavigation hauptnavigation"

cd $TEMP_FOLDER

if [ -d $GIT_NAME ]
then
  rm -R $GIT_NAME
fi

git clone git@github.com:Level8Broccoli/${GIT_NAME}.git

cd $GIT_NAME

for TYPE in $TYPES
do
  curl \
    -X GET \
    -H "Content-Type: application/json" \
    -o ./ssg/_data/$TYPE.json \
    http://localhost:1337/$TYPE
done

if [ ! $(git diff --quiet) ] || [ ! $(git diff --staged --quiet) ]
then
  git config --global user.name "GitHub Action"
  git config --global user.email "7040739+Level8Broccoli@users.noreply.github.com"
  git add .
  git commit -m 'sync data from cms'
  git push
fi
