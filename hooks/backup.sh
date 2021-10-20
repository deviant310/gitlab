#!/bin/bash

CONTAINER_ID=$(cut -c9- < /proc/1/cpuset)

gitlab-backup create BACKUP=latest

ssh -f -o StrictHostKeyChecking=no -o LogLevel=ERROR "$APP_USER@$APP_HOST" "
  export PATH=$APP_PATH;
  docker cp $CONTAINER_ID:/var/opt/gitlab/backups/latest_gitlab_backup.tar $APP_ROOT/backups/
  docker cp $CONTAINER_ID:/etc/gitlab/gitlab.rb $APP_ROOT/config/
  docker cp $CONTAINER_ID:/etc/gitlab/gitlab-secrets.json $APP_ROOT/config/
  git -C $APP_ROOT add backups
  git -C $APP_ROOT commit -m \"Automatic backup\"
  git -C $APP_ROOT push
"
