FROM gitlab/gitlab-ee:13.5.1-ee.0

COPY ./config/* /etc/gitlab/
COPY ./backups/* /var/opt/gitlab/backups/
COPY ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
