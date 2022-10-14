#!/usr/bin/env sh

TEMP_FOLDER="/tmp"
DATA_FOLDER="ssg/_data/"
IMG_FOLDER="ssg/public/images"
IMG_FILE="img.txt"
GIT_NAME="eagleslinedancers.ch"
CMS_URL="http://localhost:1337"
TYPES="seiten startseite fussnavigation hauptnavigation"

cd ${TEMP_FOLDER}

if [ -d ${GIT_NAME} ]
then
  rm -R ${GIT_NAME}
fi

if [ -f ${IMG_FILE} ]
then
  rm -R ${IMG_FILE}
fi

git clone git@github.com:Level8Broccoli/${GIT_NAME}.git

if [ -d ${GIT_NAME} ]
then
  cd ${GIT_NAME}

  for TYPE in ${TYPES}
  do
    curl \
      -X GET \
      -H "Content-Type: application/json" \
      -o ./${DATA_FOLDER}${TYPE}.json \
      ${CMS_URL}/${TYPE}

    grep \
      -oP \
      '(?<="url":").+?(?=")' \
      ./${DATA_FOLDER}${TYPE}.json \
      >> ${TEMP_FOLDER}/${IMG_FILE}
  done

  cat ${TEMP_FOLDER}/${IMG_FILE} \
    | awk '!/\/small_/ && !/\/medium_/ && !/\/large_/ && !/\/thumbnail_/' \
    | while read url; do
    curl ${CMS_URL}${url} \
      --create-dirs \
      -o ./${IMG_FOLDER}${url}
  done

  if [ ! $(git diff --quiet) ] || [ ! $(git diff --staged --quiet) ]
  then
    git config --global user.name "GitHub Action"
    git config --global user.email "7040739+Level8Broccoli@users.noreply.github.com"
    git add .
    git commit -m 'sync data from cms'
    git push
  fi
else
  ls -la
  echo "Couldn't sync data"
fi