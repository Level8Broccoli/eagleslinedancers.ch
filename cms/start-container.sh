#!/usr/bin/env bash
podman run -d -p "3333:1337" -v "eagles-cms_db:/srv/app/.tmp" -v "eagles-cms_uploads:/srv/app/public/uploads" docker.io/library/cms_eagles-cms 
