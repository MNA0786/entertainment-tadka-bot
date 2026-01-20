FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    && docker-php-ext-install zip

# Enable Apache modules
RUN a2enmod rewrite headers

# Set working directory
WORKDIR /var/www/html

# Copy all files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod 755 /var/www/html \
    && chmod 666 /var/www/html/*.csv /var/www/html/*.json /var/www/html/*.log 2>/dev/null || true \
    && touch /var/www/html/error.log \
    && chmod 666 /var/www/html/error.log \
    && mkdir -p /var/www/html/backups \
    && chmod 777 /var/www/html/backups

# PHP configuration
RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "display_errors = On" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "date.timezone = Asia/Kolkata" >> /usr/local/etc/php/conf.d/uploads.ini

# Expose port (Render.com will provide PORT)
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT/ || exit 1

# Start Apache
CMD ["apache2-foreground"]
