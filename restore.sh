if [ ! "$CONTAINER" ]; then
  echo 'CONTAINER is not defined';
  exit;
fi;

if [ ! "$(docker ps -a | grep $CONTAINER)" ]; then
  echo 'No such container';
  exit;
fi;

docker exec -it "$CONTAINER" gitlab-ctl stop puma;
docker exec -it "$CONTAINER" gitlab-ctl stop sidekiq;

docker exec -it "$CONTAINER" gitlab-backup restore BACKUP=latest

docker exec -it "$CONTAINER" gitlab-ctl reconfigure
docker restart "$CONTAINER"

