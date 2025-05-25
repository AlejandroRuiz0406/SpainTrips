FROM php:8.2

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    unzip git curl libpng-dev libjpeg-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

COPY . .

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader || true

EXPOSE 8000

CMD sh -c "php artisan config:clear && php artisan cache:clear && php -S 0.0.0.0:\${PORT:-8000} -t public"
