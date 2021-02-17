FROM ghcr.io/elephmoon/ansible-image:develop

MAINTAINER Alexandr Kizilow <alexandr.kizilow@gmail.com>

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
