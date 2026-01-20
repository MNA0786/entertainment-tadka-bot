# ============================================
# 🐳 ENTERTAINMENT TADKA BOT DOCKERFILE
# Version: 3.0 - Render.com Ready
# ============================================

FROM php:8.1-apache

# ============================================
# 🔧 INSTALL DEPENDENCIES
# ============================================

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zip \
    unzip \
    libzip-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    && docker-php-ext-install zip mbstring curl \
    && docker-php-ext-enable zip

# ============================================
# 📁 APACHE CONFIGURATION
# ============================================

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy custom Apache configuration
COPY docker/apache-config.conf /etc/apache2/sites-available/000-default.conf

# ============================================
# 📂 APPLICATION FILES
# ============================================

# Create application directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# ============================================
# 🔐 FILE PERMISSIONS
# ============================================

# Set proper permissions for Render.com
RUN chown -R www-data:www-data /var/www/html \
    && chmod 755 /var/www/html \
    && chmod 666 /var/www/html/*.csv /var/www/html/*.json /var/www/html/*.log 2>/dev/null || true \
    && touch /var/www/html/error.log \
    && chmod 666 /var/www/html/error.log

# Create writable directories
RUN mkdir -p /var/www/html/backups \
    && chmod 777 /var/www/html/backups

# ============================================
# ⚙️ PHP CONFIGURATION
# ============================================

# Copy PHP configuration
COPY docker/php-config.ini /usr/local/etc/php/conf.d/custom.ini

# Set PHP settings for Render.com
RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "display_errors = On" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/uploads.ini

# ============================================
# 🏃 HEALTH CHECK
# ============================================

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT/ || exit 1

# ============================================
# 🚀 STARTUP COMMANDS
# ============================================

# Expose port (Render.com will set PORT)
EXPOSE $PORT

# Startup script
COPY docker/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Start Apache with custom script
CMD ["/usr/local/bin/startup.sh"]