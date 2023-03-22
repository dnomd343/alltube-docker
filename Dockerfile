ARG ALPINE="alpine:3.15"

FROM ${ALPINE} as composer
# TODO: remove php-json after php8 (>=alpine:3.16)
RUN apk add php php-phar php-iconv php-openssl php-json
RUN wget https://install.phpcomposer.com/installer
RUN php installer

FROM ${ALPINE} as build
ENV ALLTUBE="3.1.1"
RUN apk add php php-phar php-mbstring php-openssl
# TODO: remove php-json after php8 (>=alpine:3.16)
RUN apk add php-dom php-gmp php-xml php-intl php-json php-gettext php-simplexml php-tokenizer php-xmlwriter
RUN wget https://github.com/Rudloff/alltube/releases/download/${ALLTUBE}/alltube-${ALLTUBE}.zip && \
    unzip alltube-${ALLTUBE}.zip
COPY --from=composer /composer.phar /usr/bin/composer
WORKDIR ./alltube/
RUN composer install --prefer-dist --no-progress --no-dev --optimize-autoloader
RUN chmod 777 ./templates_c/
WORKDIR ./config/
RUN mv ./config.example.yml ./config.yml

FROM ${ALPINE}
# TODO: remove php-json after php8 (>=alpine:3.16)
# TODO: /usr/bin/python already exist after alpine:3.17
RUN apk add --no-cache nginx python3 php-fpm php-mbstring \
      php-dom php-gmp php-xml php-intl php-json php-gettext php-simplexml php-tokenizer php-xmlwriter && \
    ln -s /usr/bin/python3 /usr/bin/python
COPY --from=build /alltube/ /var/www/alltube/
COPY ./init.sh /usr/bin/alltube
COPY ./nginx/ /etc/nginx/
EXPOSE 80
ENTRYPOINT ["alltube"]
