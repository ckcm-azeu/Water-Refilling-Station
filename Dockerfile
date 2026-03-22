# ============================================================================
# Azeu Water Station - Optimized Production Dockerfile for Render.com
# ============================================================================
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    APACHE_DOCUMENT_ROOT=/var/www/html

# Install system dependencies including required build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    openssl \
    git \
    build-essential \
    autoconf \
    oniguruma-source \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions for MySQL and encryption
RUN docker-php-ext-configure mbstring --enable-mbstring && \
    docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    mbstring

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy application files early
COPY . /var/www/html/

# Create necessary directories with proper permissions
RUN mkdir -p /var/www/html/logs \
    /var/www/html/assets/uploads/items \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/logs \
    && chmod -R 775 /var/www/html/assets/uploads

# Create .htaccess for logs directory
RUN echo "Deny from all" > /var/www/html/logs/.htaccess

# Configure Apache for Render.com (uses PORT environment variable)
RUN echo '#!/bin/bash' > /usr/local/bin/docker-entrypoint.sh && \
    echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'export PORT=${PORT:-3000}' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'echo "Listen $PORT" > /etc/apache2/ports.conf' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'sed -i "s/<VirtualHost \*:80>/<VirtualHost *:$PORT>/g" /etc/apache2/sites-available/000-default.conf' >> /usr/local/bin/docker-entrypoint.sh && \
    echo 'exec apache2-foreground' >> /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Configure Apache site
RUN echo '<VirtualHost *:3000>' > /etc/apache2/sites-available/000-default.conf && \
    echo '    ServerAdmin admin@azeuwater.com' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    DocumentRoot /var/www/html' >> /etc/apache2/sites-available/000-default.conf && \
    echo '' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    <Directory /var/www/html>' >> /etc/apache2/sites-available/000-default.conf && \
    echo '        Options Indexes FollowSymLinks' >> /etc/apache2/sites-available/000-default.conf && \
    echo '        AllowOverride All' >> /etc/apache2/sites-available/000-default.conf && \
    echo '        Require all granted' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    </Directory>' >> /etc/apache2/sites-available/000-default.conf && \
    echo '' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/000-default.conf && \
    echo '' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Header always set X-Content-Type-Options "nosniff"' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Header always set X-Frame-Options "SAMEORIGIN"' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Header always set X-XSS-Protection "1; mode=block"' >> /etc/apache2/sites-available/000-default.conf && \
    echo '</VirtualHost>' >> /etc/apache2/sites-available/000-default.conf

# Configure PHP for production
RUN echo 'display_errors = Off' > /usr/local/etc/php/conf.d/custom.ini && \
    echo 'display_startup_errors = Off' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'log_errors = On' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'error_log = /var/log/php-errors.log' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'upload_max_filesize = 50M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'post_max_size = 50M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'date.timezone = Asia/Manila' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'session.cookie_httponly = On' >> /usr/local/etc/php/conf.d/custom.ini && \
    echo 'session.cookie_samesite = Lax' >> /usr/local/etc/php/conf.d/custom.ini

# Create PHP error log
RUN touch /var/log/php-errors.log && chmod 666 /var/log/php-errors.log

# Expose port 3000 (default, will be overridden by PORT env var)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start Apache with entrypoint script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start Apache
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
