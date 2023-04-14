FROM composer:2.0.12

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql