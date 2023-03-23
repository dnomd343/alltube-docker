ARG ALPINE="alpine:3.15"

# TODO: remove php-json after php8 (>=alpine:3.16)
# TODO: /usr/bin/python already exist (>=alpine:3.17)

FROM ${ALPINE} AS composer
RUN apk add php-json php-phar php-mbstring php-openssl
RUN wget https://install.phpcomposer.com/installer -O - | php

FROM ${ALPINE} AS yt-dlp
ENV YTDLP="2023.03.04"
RUN wget https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP}/yt-dlp
RUN chmod +x yt-dlp

FROM ${ALPINE} AS alltube
RUN apk add php-json php-phar php-mbstring php-openssl
RUN apk add patch php-dom php-gmp php-xml php-intl php-gettext php-simplexml php-tokenizer php-xmlwriter
ENV ALLTUBE="3.1.1"
RUN wget https://github.com/Rudloff/alltube/archive/${ALLTUBE}.tar.gz -O - | tar xzf -
COPY --from=composer /composer.phar /usr/bin/composer
WORKDIR ./alltube-${ALLTUBE}/
RUN composer install --no-interaction --optimize-autoloader --no-dev
RUN mv ./config/config.example.yml ./config/config.yml
COPY ./attach.css /tmp/
RUN cat /tmp/attach.css >> ./css/style.css
RUN chmod 777 ./templates_c/
RUN mv $(pwd) /alltube/

FROM ${ALPINE} AS build
RUN apk add php-fpm
WORKDIR /release/usr/bin/
RUN ln -s /usr/bin/python3 /release/usr/bin/python
WORKDIR /release/etc/php7/php-fpm.d/
RUN sed 's?127.0.0.1:9000?/run/php-fpm.sock?' /etc/php7/php-fpm.d/www.conf > www.conf
COPY --from=alltube /alltube/ /release/var/www/alltube/
COPY --from=yt-dlp /yt-dlp /release/usr/bin/
COPY ./init.sh /release/usr/bin/alltube
COPY ./nginx/ /release/etc/nginx/

FROM ${ALPINE}
RUN apk add --no-cache nginx ffmpeg python3 php-fpm php-json php-mbstring php-openssl \
      php-dom php-gmp php-xml php-intl php-gettext php-simplexml php-tokenizer php-xmlwriter
COPY --from=build /release/ /
EXPOSE 80
ENTRYPOINT ["alltube"]
