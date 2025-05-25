FROM php:8.2-fpm

# Establece el directorio de trabajo
WORKDIR /var/www

# Instala extensiones necesarias
RUN apt-get update && apt-get install -y \
    unzip git curl libpng-dev libjpeg-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Copia todos los archivos del proyecto
COPY . .

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instala dependencias
RUN composer install --no-dev --optimize-autoloader || true

# Expone el puerto usado por php artisan serve
EXPOSE 8000

# Usa sh para evaluar correctamente $PORT
CMD sh -c "php artisan config:clear && php artisan cache:clear && php artisan serve --host=0.0.0.0 --port=\${PORT:-8000}"
