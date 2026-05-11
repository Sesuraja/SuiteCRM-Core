FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl \
    libicu-dev libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libldap2-dev \
    nodejs npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
       pdo \
       pdo_mysql \
       intl \
       zip \
       gd \
       ldap

RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN npm install -g corepack
RUN corepack prepare yarn@4.10.3 --activate

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN yarn install --immutable
RUN yarn build

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
