FROM php:8.2-fpm
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

# Download and Install wkhtmltopdf and libssl1.1 in a single layer
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    apt-get install -f -y && \
    rm -f libssl1.1_1.1.1f-1ubuntu2_amd64.deb

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
