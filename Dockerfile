FROM alpine as asset
COPY ./ /
RUN sh /asset.sh

FROM alpine
COPY --from=asset /tmp/alltube/ /var/www/alltube/
RUN apk --update add --no-cache nginx ffmpeg python3 php php-fpm php-dom php-xml php-zip php-gmp php-json php-phar php-intl php-openssl php-mbstring php-gettext php-xmlwriter php-tokenizer php-simplexml && \
    rm -rf /var/www/localhost && rm -rf /etc/nginx/http.d && \
    mv -f /var/www/alltube/nginx.conf /etc/nginx/ && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    mv /var/www/alltube/init.sh / && \
    php /var/www/alltube/composer-setup.php && rm -f /var/www/alltube/composer-setup.php && \
    mv ./composer.phar /usr/bin/composer && \
    chmod 777 /var/www/alltube/templates_c && \
    cd /var/www/alltube && composer install && \
    cd ./config && mv config.example.yml config.yml
EXPOSE 80
CMD ["sh","init.sh"]
