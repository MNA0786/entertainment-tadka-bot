# ============================================
# 🐳 ENTERTAINMENT TADKA BOT DOCKERFILE
# Simplified Version - Render.com Ready
# ============================================

FROM php:8.1-apache

# ============================================
# 🔧 INSTALL DEPENDENCIES
# ============================================

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    zip \
    unzip \
    && docker-php-ext-install zip

# ============================================
# 📁 APACHE CONFIGURATION
# ============================================

# Enable Apache modules
RUN a2enmod rewrite headers

# Create Apache config
RUN echo '<VirtualHost *:$PORT>\n\
    ServerAdmin admin@entertainmenttadka.com\n\
    DocumentRoot /var/www/html\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
    <Directory /var/www/html>\n\
        Options FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    LimitRequestBody 104857600\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

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

# Set PHP settings for Render.com
RUN echo "upload_max_filesize = 100M\n\
post_max_size = 100M\n\
max_execution_time = 300\n\
memory_limit = 256M\n\
display_errors = On\n\
error_reporting = E_ALL\n\
date.timezone = Asia/Kolkata" > /usr/local/etc/php/conf.d/custom.ini

# ============================================
# 🚀 STARTUP SCRIPT
# ============================================

# Create startup script
RUN echo '#!/bin/bash\n\
# Startup script\n\
\n\
echo "Starting Entertainment Tadka Bot..."\n\
\n\
# Check BOT_TOKEN\n\
if [ -z "$BOT_TOKEN" ]; then\n\
    echo "ERROR: BOT_TOKEN environment variable is not set!"\n\
    exit 1\n\
fi\n\
\n\
# Set Apache port\n\
if [ -z "$PORT" ]; then\n\
    PORT=80\n\
fi\n\
\n\
sed -i "s/\\$PORT/$PORT/g" /etc/apache2/sites-available/000-default.conf\n\
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf\n\
\n\
echo "Starting Apache on port $PORT..."\n\
exec apache2-foreground' > /usr/local/bin/startup.sh \
    && chmod +x /usr/local/bin/startup.sh

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

# Start Apache with custom script
CMD ["/usr/local/bin/startup.sh"]
