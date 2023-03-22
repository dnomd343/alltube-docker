#!/usr/bin/env sh

if [ -n "$TITLE" ]; then
  sed -i "/^appName:/cappName: $TITLE" /var/www/alltube/config/config.yml
fi

/usr/sbin/nginx
exec /usr/sbin/php-fpm7 -F
