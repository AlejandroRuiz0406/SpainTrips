FROM php:8.2-apache

# Habilitar módulos necesarios
RUN apt-get update && apt-get install -y \
    unzip git curl libpng-dev libjpeg-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Copiar archivos del proyecto
COPY . /var/www/html

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader || true

# Establecer permisos correctos (opcional pero recomendado)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Asegúrate de que .htaccess esté habilitado
RUN a2enmod rewrite

# Exponer el puerto (Apache)
EXPOSE 80

CMD ["apache2-foreground"]
