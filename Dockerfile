FROM gitlab/gitlab-ee:13.5.1-ee.0

COPY --chown=git:git ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
