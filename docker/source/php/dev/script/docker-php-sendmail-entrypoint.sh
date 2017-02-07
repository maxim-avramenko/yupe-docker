#!/bin/sh
set -e
echo "127.0.0.1 localhost localhost.localdomain $HOSTNAME" >> /etc/hosts
yes | sendmailconfig
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"