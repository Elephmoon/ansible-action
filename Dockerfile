FROM ghcr.io/elephmoon/ansible-image:main

MAINTAINER Alexandr Kizilow <alexandr.kizilow@gmail.com>

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]