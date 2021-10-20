# GitLab VCS + restore from backup + saving backup file hook

## Installation with Docker

1. Create `.env` file from `.env.example`, replace values if necessary.
   ```shell
   cp .env.example .env
   ```
2. Run the container
   ```shell
   docker-compose up -d
   ```
   
**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary

3. Copy necessary data to your container
   ```shell
   for f in ./config/*; do docker cp $f gitlab-web-1:/etc/gitlab/; done
   for f in ./backups/*; do docker cp $f gitlab-web-1:/var/opt/gitlab/backups/; done
   for f in ./hooks/*; do docker cp $f gitlab-web-1:/opt/gitlab/embedded/service/gitlab-rails/file_hooks/; done
   ```
4. Generate ssh keys inside the container
   ```shell
   docker exec -it gitlab-web-1 ssh-keygen -q -t rsa -N '' -f /var/opt/gitlab/.ssh/id_rsa -C root@gitlab_web
   ```
5. Add generated public key to authorized_keys on your host
   ```shell
   docker exec -it gitlab-web-1 cat /var/opt/gitlab/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```
   
6. Reconfigure gitlab and restart your container

   ```shell
   docker exec -it gitlab-web-1 gitlab-ctl reconfigure
   docker restart gitlab-web-1
   ```

## Restore from backup

**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary

1. Stop the processes that are connected to the database 
   ```shell
   docker exec -it gitlab-web-1 gitlab-ctl stop puma
   docker exec -it gitlab-web-1 gitlab-ctl stop sidekiq
   ```
2. Run the restore
   ```shell
   # replace "latest" to your custom file name, if necessary, e.g. "11493107454_2018_04_25_10.6.4-ce"
   
   docker exec -it gitlab-web-1 gitlab-backup restore BACKUP=latest
   ```
3. Reconfigure gitlab and restart your container

   ```shell
   docker exec -it gitlab-web-1 gitlab-ctl reconfigure
   docker restart gitlab-web-1
   ```

## Back up

File hook `hooks/backup.sh` will generate backup file on every event triggered in GitLab. Then it will send to VCS of this repository. If you want to do it manually, run the following command:

**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary
```shell
docker exec -it --user git gitlab-web-1 /opt/gitlab/embedded/service/gitlab-rails/file_hooks/backup.sh
```
or validate your file hooks (will execute all file hooks)

```shell
docker exec -it gitlab-web-1 gitlab-rake file_hooks:validate
```
