FROM gitlab/gitlab-ee:13.12.15-ee.0

COPY --chown=git:git ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
COPY ./config/* /etc/gitlab/
