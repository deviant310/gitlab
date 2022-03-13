FROM gitlab/gitlab-ee:14.1.8-ee.0

COPY --chown=root:root ./config/* /etc/gitlab/
COPY --chown=git:git ./backups/* /var/opt/gitlab/backups/
COPY --chown=git:git ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
