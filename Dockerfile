FROM gitlab/gitlab-ee:14.1.8-ee.0

COPY --chown=git:git ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
COPY ./config/* /etc/gitlab/
