# GitLab VCS + restore from backup

## Installation

1. Run the container

   ```shell
   docker-compose up -d
   ```
   
3. Restore from backup
   ```shell
   # Stop the processes that are connected to the database
   docker exec -it gitlab_web_1 gitlab-ctl stop puma
   docker exec -it gitlab_web_1 gitlab-ctl stop sidekiq
   
   # Run the restore
   docker exec -it gitlab_web_1 gitlab-backup restore BACKUP=11493107454_2018_04_25_10.6.4-ce
   ```
4. Reconfigure and restart your build

   ```shell
   docker exec -it gitlab_web_1 gitlab-ctl reconfigure
   docker restart gitlab_web_1
   ```
