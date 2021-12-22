#!/bin/bash

CONTAINER_ID=$(cut -c9- < /proc/1/cpuset)

gitlab-backup create BACKUP=latest

ssh -f -o StrictHostKeyChecking=no -o LogLevel=ERROR "$APP_ROOT_USERNAME@host.docker.internal" "
  export PATH=$APP_SHELL_PATH;
  docker cp $CONTAINER_ID:/var/opt/gitlab/backups/latest_gitlab_backup.tar $APP_HOME_DIR/backups/
  docker cp $CONTAINER_ID:/etc/gitlab/gitlab.rb $APP_HOME_DIR/config/
  docker cp $CONTAINER_ID:/etc/gitlab/gitlab-secrets.json $APP_HOME_DIR/config/
  git -C $APP_HOME_DIR add backups
  git -C $APP_HOME_DIR commit -m \"Automatic backup\"
  git -C $APP_HOME_DIR push
"
