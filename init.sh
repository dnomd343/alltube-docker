#!/usr/bin/env sh

CONFIG="/var/www/alltube/config/config.yml"

sed -i "s,^audioBitrate:.*,audioBitrate: 320," "${CONFIG}"
sed -i "s,^youtubedl:.*,youtubedl: /usr/bin/yt-dlp," "${CONFIG}"

if [ -n "$TITLE" ]; then
  echo "Title: ${TITLE}"
  sed -i "s,^appName:.*,appName: ${TITLE}," "${CONFIG}"
fi

if [ "$REMUX" = "TRUE" ] || [ "$REMUX" = "ON" ]; then
  echo "Remux enabled"
  sed -i "s,^remux:.*,remux: true," "${CONFIG}"
fi

if [ "$STREAM" = "TRUE" ] || [ "$STREAM" = "ON" ]; then
  echo "Stream enabled"
  sed -i "s,^stream:.*,stream: ask," "${CONFIG}"
fi

if [ "$CONVERT" = "TRUE" ] || [ "$CONVERT" = "ON" ]; then
  echo "Convert enabled"
  sed -i "s,^convert:.*,convert: true," "${CONFIG}"
  sed -i "s,^convertAdvanced:.*,convertAdvanced: true," "${CONFIG}"
fi

echo "yt-dlp version: $(yt-dlp --version)"

/usr/sbin/nginx
exec /usr/sbin/php-fpm7 -F
