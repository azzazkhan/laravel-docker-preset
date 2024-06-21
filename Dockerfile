FROM serversideup/php:8.3-fpm-nginx

ENV PHP_OPCACHE_ENABLE 1
ENV APP_BASE_DIR /var/www
ENV COMPOSER_ALLOW_SUPERUSER 0
ENV NGINX_WEBROOT /var/www/public
ENV PHP_MAX_EXECUTION_TIME 30

WORKDIR /var/www

USER root

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update && apt-get install -y vim supervisor nodejs iputils-ping
RUN npm i -g yarn

RUN install-php-extensions bcmath decimal exif ffi gd grpc intl opcache pcntl \
    pdo_mysql pdo_pgsql redis swoole

RUN apt-get autoremove && apt-get autoclean

COPY nginx/nginx.conf.template /etc/nginx/nginx.conf.template
COPY nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY nginx/healthcheck.conf /etc/nginx/healthcheck.conf
COPY nginx/conf.d/ /etc/nginx/conf.d/
COPY nginx/site-opts.d/ /etc/nginx/site-opts.d/

USER www-data
