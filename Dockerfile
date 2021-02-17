FROM ghcr.io/elephmoon/ansible-image:test

MAINTAINER Alexandr Kizilow <alexandr.kizilow@gmail.com>

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
