# ============================================================================
# Azeu Water Station - Production Dockerfile for Render.com + TiDBCloud
# Version: 2.0 (Improved - No dependency conflicts)
# ============================================================================

FROM php:8.1-apache

# Set working directory and environment variables
WORKDIR /var/www/html
ENV DEBIAN_FRONTEND=noninteractive \
    APACHE_DOCUMENT_ROOT=/var/www/html

# Step 1: Update package lists and install only essential dependencies
# (Avoid optional libraries that may not exist in all Debian versions)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    openssl \
    git \
    && rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Step 2: Install only essential PHP extensions (avoiding problematic ones like mbstring)
# PDO and PDO MySQL are pre-compiled in the base image, so this is safe
RUN docker-php-ext-install pdo pdo_mysql

# Step 3: Enable required Apache modules
RUN a2enmod rewrite headers

# Step 4: Copy application code
COPY . /var/www/html/

# Step 5: Create required directories and set permissions
RUN mkdir -p /var/www/html/logs /var/www/html/assets/uploads/items && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    chmod -R 775 /var/www/html/logs /var/www/html/assets/uploads && \
    echo "Deny from all" > /var/www/html/logs/.htaccess

# Step 6: Configure PHP for production
RUN mkdir -p /usr/local/etc/php/conf.d && \
    echo 'display_errors = Off' > /usr/local/etc/php/conf.d/production.ini && \
    echo 'display_startup_errors = Off' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'log_errors = On' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'error_log = /var/log/php-errors.log' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'upload_max_filesize = 50M' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'post_max_size = 50M' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'date.timezone = Asia/Manila' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'session.cookie_httponly = On' >> /usr/local/etc/php/conf.d/production.ini && \
    echo 'session.cookie_samesite = Lax' >> /usr/local/etc/php/conf.d/production.ini && \
    touch /var/log/php-errors.log && \
    chmod 666 /var/log/php-errors.log

# Step 7: Create startup script for Render.com PORT handling
RUN cat > /usr/local/bin/docker-entrypoint.sh << 'EOF'
#!/bin/bash
set -e

# Use Render.com PORT environment variable
PORT=${PORT:-3000}

# Configure Apache to listen on the specified port
echo "Listen $PORT" > /etc/apache2/ports.conf

# Update VirtualHost to use the specified port
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:$PORT>/g" /etc/apache2/sites-available/000-default.conf

# Start Apache
exec apache2-foreground
EOF
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Step 8: Configure Apache VirtualHost
RUN cat > /etc/apache2/sites-available/000-default.conf << 'EOF'
<VirtualHost *:3000>
    ServerAdmin admin@azeuwater.com
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    # Security headers
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
EOF

# Expose port 3000 (Render.com will override via PORT env var)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start application
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start Apache
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
