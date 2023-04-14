FROM php:7.4-fpm-alpine

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql

#https://stackoverflow.com/questions/46465204/problems-installing-mongodb-pecl-package-tmp-pear-temp-mongodb-configure-co
RUN apk update &&\
    apk add --update --virtual build_deps bash gcc g++ autoconf make openssl-dev pcre-dev &&\
    docker-php-source extract &&\
    /bin/bash -lc "pecl install -f mongodb-1.8.2.tgz" && \
    docker-php-ext-enable mongodb && \
    docker-php-source delete && \
    apk del build_deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
    
# COPY php/php.ini /php.ini
# RUN mv /php.ini "$PHP_INI_DIR/php.ini"

RUN apk add --no-cache zip libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

