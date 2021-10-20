#!/bin/bash

gitlab-backup create BACKUP=latest

ssh -f -o StrictHostKeyChecking=no -o LogLevel=ERROR "$APP_USER@$APP_HOST" "
  export PATH=$APP_PATH;
  git -C $APP_ROOT add data/backups
  git -C $APP_ROOT commit -m \"Automatic backup\"
  git -C $APP_ROOT push
"
