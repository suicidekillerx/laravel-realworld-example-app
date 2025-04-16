FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git zip unzip curl \
    libzip-dev libpng-dev libonig-dev libxml2-dev \
    libjpeg62-turbo-dev libfreetype6-dev \
    libxslt-dev libgd-dev libmcrypt-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
	mysqli \  
        mbstring \
        zip \
        gd \
        xml \
        bcmath \
        exif \
        sockets \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader



# Expose Apache
EXPOSE 80
