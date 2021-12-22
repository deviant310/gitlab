if [ ! "$CONTAINER" ]; then
  echo 'CONTAINER is not defined';
  exit;
fi;

if [ ! "$(docker ps -a | grep $CONTAINER)" ]; then
  echo 'No such container';
  exit;
fi;

for f in ./config/*;
  do docker cp "$f" "$CONTAINER":/etc/gitlab/;
done;

for f in ./backups/*;
  do docker cp "$f" "$CONTAINER":/var/opt/gitlab/backups/;
done;

docker exec -it "$CONTAINER" chown -R root:root /etc/gitlab/;
docker exec -it "$CONTAINER" chown -R git:git /var/opt/gitlab/backups/;

docker exec -it "$CONTAINER" gitlab-ctl stop puma;
docker exec -it "$CONTAINER" gitlab-ctl stop sidekiq;

docker exec -it "$CONTAINER" gitlab-backup restore BACKUP=latest

docker exec -it "$CONTAINER" gitlab-ctl reconfigure
docker restart "$CONTAINER"

