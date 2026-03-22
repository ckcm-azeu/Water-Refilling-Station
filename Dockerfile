# Use official PHP image with Apache
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    zip \
    unzip \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    mysqli \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath \
    gd

# Enable Apache modules
RUN a2enmod rewrite headers ssl

# Create Apache configuration for dynamic PORT
RUN echo '<VirtualHost *:${PORT}> \n\
    ServerAdmin webmaster@localhost \n\
    DocumentRoot /var/www/html \n\
    \n\
    <Directory /var/www/html> \n\
        Options Indexes FollowSymLinks \n\
        AllowOverride All \n\
        Require all granted \n\
    </Directory> \n\
    \n\
    ErrorLog ${APACHE_LOG_DIR}/error.log \n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined \n\
    \n\
    Header always set X-Content-Type-Options "nosniff" \n\
    Header always set X-Frame-Options "SAMEORIGIN" \n\
    Header always set X-XSS-Protection "1; mode=block" \n\
    Header always set Referrer-Policy "strict-origin-when-cross-origin" \n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Copy application files
COPY . /var/www/html/

# Create necessary directories with proper permissions
RUN mkdir -p /var/www/html/logs \
    /var/www/html/assets/uploads/items \
    /var/www/html/tmp \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/logs \
    && chmod -R 775 /var/www/html/assets/uploads

# Create .htaccess for logs directory
RUN echo "Deny from all" > /var/www/html/logs/.htaccess

# Configure PHP for production
RUN echo 'display_errors = Off' > /usr/local/etc/php/conf.d/custom.ini && \
    echo 'display_startup_errors = Off' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'log_errors = On' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'error_log = /var/www/html/logs/php_errors.log' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'upload_max_filesize = 10M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'post_max_size = 10M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'memory_limit = 256M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'session.cookie_secure = On' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'session.cookie_httponly = On' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'session.cookie_samesite = Strict' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'date.timezone = Asia/Manila' >> /usr/local/etc/php/conf.d/custom.ini

# Create startup script for PORT handling
RUN echo '#!/bin/bash' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'export PORT=${PORT:-80}' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'echo "Listen ${PORT}" > /etc/apache2/ports.conf' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec apache2-foreground' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port (Render.com uses PORT env variable)
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/maintenance.php || exit 1

# Start Apache
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
