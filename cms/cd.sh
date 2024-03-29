#!/usr/bin/env sh

TEMP_FOLDER="/tmp"
DATA_FOLDER="astro-ssg/src/_data/" # JSON files, content and structure from CMS
ASSETS_FOLDER="astro-ssg/src/_assets/" # Image files, which get handled by SSG
PUBLIC_FOLDER="astro-ssg/public/_uploads/" # Everything else (e.g. PDF file for download)
DATA_URL_LIST_FILE="img.txt"
GIT_NAME="eagleslinedancers.ch"
CMS_URL="http://localhost:1337"
TYPES="seiten startseite fussnavigation hauptnavigation"
IMAGE_TYPES="JPG jpg jpeg PNG png GIF gif"

# Decprecated (old SSG)

DEPR_DATA_FOLDER="ssg/_data/"
DEPR_IMG_FOLDER="ssg/public/images/uploads"

# Deprecated /end

cd ${TEMP_FOLDER}

if [ -d ${GIT_NAME} ]
then
  rm -R ${GIT_NAME}
fi

if [ -f ${DATA_URL_LIST_FILE} ]
then
  rm -R ${DATA_URL_LIST_FILE}
fi

git clone git@github.com:Level8Broccoli/${GIT_NAME}.git

if [ -d ${GIT_NAME} ]
then
  cd ${GIT_NAME}

  # delete all generated files

  if [ -d ${PUBLIC_FOLDER} ]
  then
    rm -R ${PUBLIC_FOLDER}
  fi
  mkdir -p ${PUBLIC_FOLDER}

  printf "# README\n\nFolder gets filled by script. Don't touch manually." > ./${PUBLIC_FOLDER}README.md

  if [ -d ${ASSETS_FOLDER} ]
  then
    rm -R ${ASSETS_FOLDER}
  fi
  mkdir -p ${ASSETS_FOLDER}

  printf "# README\n\nFolder gets filled by script. Don't touch manually." > ./${ASSETS_FOLDER}README.md

  if [ -d ${DATA_FOLDER} ]
  then
    rm -R ${DATA_FOLDER}
  fi
  mkdir -p ${DATA_FOLDER}

  printf "# README\n\nFolder gets filled by script. Don't touch manually." > ./${DATA_FOLDER}README.md

  # Deprecated (old SSG)

  if [ -d ${DEPR_IMG_FOLDER} ]
  then
    rm -R ${DEPR_IMG_FOLDER}
  fi

  # Deprecated /end
  
  # Save all JSON files and paths to images and other files
  
  for TYPE in ${TYPES}
  do

    # Deprecated (old SSG)

    curl \
      -X GET \
      -H "Content-Type: application/json" \
      -o ./${DEPR_DATA_FOLDER}${TYPE}.json \
      ${CMS_URL}/${TYPE}
    
    # Deprecated /end

    curl \
      -X GET \
      -H "Content-Type: application/json" \
      -o ./${DATA_FOLDER}${TYPE}.json \
      ${CMS_URL}/${TYPE}

    grep \
      -oP \
      '(?<="url":").+?(?=")' \
      ./${DATA_FOLDER}${TYPE}.json \
      | awk '!/\/small_/ && !/\/medium_/ && !/\/large_/ && !/\/thumbnail_/' \
      >> ${TEMP_FOLDER}/${DATA_URL_LIST_FILE}
  done

  # Prepare URLs for files
  
  sed -i -e "s/^/$(printf '%s\n' "${CMS_URL}" | sed -e 's/[\/&]/\\&/g')/" ${TEMP_FOLDER}/${DATA_URL_LIST_FILE}

  # Save all files
  
  wget \
    -i ${TEMP_FOLDER}/${DATA_URL_LIST_FILE} \
    -P ./${PUBLIC_FOLDER}

  # Deprecated (old SSG)

  wget \
    -i ${TEMP_FOLDER}/${DATA_URL_LIST_FILE} \
    -P ./${DEPR_IMG_FOLDER}

  # Deprecated /end

  # Move the files accordingly

  for TYPE in ${IMAGE_TYPES}
  do
    mv ./${PUBLIC_FOLDER}*.${TYPE} ./${ASSETS_FOLDER}
  done
  

  # Check in the changes

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
