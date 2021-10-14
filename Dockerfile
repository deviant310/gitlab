FROM gitlab/gitlab-ee:13.5.1-ee.0

COPY backup_config/* /etc/gitlab/
COPY ./backups/* /var/opt/gitlab/backups/
