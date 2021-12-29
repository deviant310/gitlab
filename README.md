# GitLab VCS + restore from backup + saving backup file hook

**IMPORTANT:**
Your gitlab environment will have access to your host environment via ssh and will try to push changes into this repo. So this repo shouldn't have any collaborators. After cloning this repo CHANGE remote origin on yours which you have access, so your host can push to your remote. Make this repo private because it will keep your credentials.

## Installation with Docker

0. Install OpenSSH server to your host machine
   ```shell
   sudo apt install openssh-server
   ```
   Allow authentication by public key. Uncomment line in your `/etc/ssh/sshd_config`:
   ```text
   PubkeyAuthentication yes
   ```
   Restart your ssh service
   ```shell
   sudo service ssh restart
   ```
1. Create `.env` file from `.env.example`, replace values if necessary.
   ```shell
   cp .env.example .env
   ```
   At least you must change `APP_USER` value and set your host username

2. Run the container
   ```shell
   docker-compose up -d
   ```

**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary

3. Generate ssh keys inside the container
   ```shell
   docker exec -it --user git gitlab-web-1 ssh-keygen -q -t rsa -N '' -f /var/opt/gitlab/.ssh/id_rsa -C root@gitlab_web
   ```
   
4. Add generated public key to authorized_keys on your host
   ```shell
   docker exec -it gitlab-web-1 cat /var/opt/gitlab/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```

5. Reconfigure gitlab and restart your container

   ```shell
   docker exec -it gitlab-web-1 gitlab-ctl reconfigure
   docker restart gitlab-web-1
   ```

## Restore from backup

**IMPORTANT:**
Actual for second and further deployments. Beware of using existing backups at first deployment due to gitlab builds versions conflicts. Just skip this paragraph at first deployment. In further deployments you will find your backups and configs in appropriate folders of this repo: `backups` and `config`.

To restore from existing backup run the following command:

**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary

```shell
CONTAINER=gitlab-web-1 ./restore.sh
```

## Back up

File hook `hooks/backup.sh` will generate backup file on every event triggered in GitLab. Then it will be sent to VCS of this repository. If you want to do it manually, run the following command:

**NOTE:**
Replace `gitlab-web-1` to your container name, if necessary
```shell
docker exec -it --user git gitlab-web-1 /opt/gitlab/embedded/service/gitlab-rails/file_hooks/backup.sh
```
or validate your file hooks (will execute all file hooks)

```shell
docker exec -it gitlab-web-1 gitlab-rake file_hooks:validate
```
