#!/usr/bin/env bash

# This sadly does not contain the correct `/srv/app/cd.sh`. Please use the one in the git repo.

podman run -d \
  --restart=always \
  -p "3333:1337" \
  -v "eagles-cms_db:/srv/app/.tmp" \
  -v "eagles-cms_uploads:/srv/app/public/uploads" \
  -v "eagles-cms_cd:/srv/app/.cd" \
  docker.io/library/cms_eagles-cms
