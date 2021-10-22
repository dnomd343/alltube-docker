if [ -n "$TITLE" ]; then
  sed -i "/^appName:/cappName: $TITLE" /var/www/alltube/config/config.yml
fi
/usr/sbin/php-fpm7
/usr/sbin/nginx
read -n 1
