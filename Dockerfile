FROM gitlab/gitlab-ee:14.7.5-ee.0

COPY --chown=git:git ./hooks/* /opt/gitlab/embedded/service/gitlab-rails/file_hooks/
