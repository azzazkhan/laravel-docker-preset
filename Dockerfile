FROM serversideup/php:8.3-fpm-nginx

ENV PHP_OPCACHE_ENABLE=1
ENV APP_BASE_DIR=/var/www
ENV COMPOSER_ALLOW_SUPERUSER=0
ENV NGINX_WEBROOT=/var/www/public
ENV PHP_MAX_EXECUTION_TIME=30

# Custom NGINX template variables
ENV NGINX_UPLOAD_LIMIT=10M
ENV NGINX_REQUEST_TIMEOUT=30
ENV HEALTHCHECK_TIMEOUT=5s

WORKDIR /var/www

USER root

# Install and configure Node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update && apt-get install -y vim nodejs iputils-ping
RUN npm i -g yarn

# Install Bun and Deno
RUN curl -fsSL https://bun.sh/install | bash
RUN curl -fsSL https://deno.land/install.sh | sh

# Install required PHP extensions
RUN install-php-extensions bcmath decimal exif ffi gd grpc intl opcache pcntl \
    pdo_mysql pdo_pgsql redis swoole

# Clean up the image to remove stale packages
RUN apt-get autoremove && apt-get autoclean

# Remove existing NGINX config to prevent conflicts
RUN rm -rf /etc/nginx/nginx.conf.template \
    /etc/nginx/conf.d \
    /etc/nginx/server-opts.d \
    /etc/nginx/site-opts.d \
    /etc/nginx/snippets

# Add custom NGINX configuration and custom entrypoint startup script
COPY --chmod=755 nginx/ /etc/nginx/
COPY --chmod=755 entrypoint.d/ /etc/entrypoint.d/

# Configure proper permissions for NGINX configuration
RUN docker-php-serversideup-s6-init
RUN docker-php-serversideup-set-file-permissions --owner www-data:www-data --service nginx

USER www-data
