FROM php:8.2-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libjpeg-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . .


RUN composer install --no-dev --optimize-autoloader || true
RUN cat /var/www/storage/logs/laravel.log || true
RUN ls -la && cat composer.json || true

RUN chown -R www-data:www-data /var/www \
 && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

CMD php artisan serve --host=0.0.0.0 --port=${PORT}
