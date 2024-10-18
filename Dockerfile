FROM php:8.1-fpm
MAINTAINER Shawon

# Argument for custom user
ARG user
ARG uid

# Install Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip wget dpkg fontconfig \
    libfreetype6 libjpeg62-turbo libxrender1 xfonts-75dpi xfonts-base mariadb-client \
    libzip-dev zlib1g-dev libjpeg-dev libwebp-dev libfreetype-dev libmagickwand-dev \
    cron vim \
    && docker-php-ext-install zip gd pdo_mysql intl mbstring exif pcntl bcmath \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy PHP configuration
COPY .docker/app/php-fpm.ini /usr/local/etc/php/conf.d/php-fpm.ini

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www
RUN chown -R www-data:www-data /var/www

# Switch to custom user
USER $user
