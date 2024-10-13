#!/bin/sh

# Base Laravel optimizations
php "$APP_BASE_DIR/artisan" config:clear >/dev/null 2>&2
php "$APP_BASE_DIR/artisan" migrate --force >/dev/null 2>&2
php "$APP_BASE_DIR/artisan" storage:link --force >/dev/null 2>&2
php "$APP_BASE_DIR/artisan" optimize >/dev/null 2>&2

# Write your code here ...

echo "✅ Laravel optimzations script completed"
