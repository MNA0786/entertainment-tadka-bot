#!/bin/bash
# ============================================
# 🛠️ SETUP SCRIPT FOR ENTERTAINMENT TADKA BOT
# Run this before deployment
# ============================================

set -e

echo "============================================"
echo "🛠️  SETUP: ENTERTAINMENT TADKA BOT"
echo "============================================"

# ============================================
# 📁 CREATE DIRECTORY STRUCTURE
# ============================================

echo "📁 Creating directory structure..."

mkdir -p docker
mkdir -p backups
mkdir -p logs
mkdir -p data

# ============================================
# 📄 CREATE REQUIRED FILES
# ============================================

echo "📄 Creating required files..."

# Create empty files with headers
echo "movie_name,message_id,date,channel_id,channel_name,channel_emoji,added_timestamp" > movies.csv
echo '{"users": {}, "total_requests": 0, "message_logs": [], "created": "'$(date -Iseconds)'"}' > users.json
echo '{"total_movies": 0, "total_users": 0, "total_searches": 0, "channels_stats": {}, "last_updated": "'$(date -Iseconds)'", "created": "'$(date -Iseconds)'"}' > bot_stats.json

# Create channels tracker with your channels
cat > channels_tracker.json << 'EOF'
{
  "-1003181705395": {
    "name": "Movies and Webseries",
    "emoji": "🎬",
    "username": "@EntertainmentTadka786",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1003251791991": {
    "name": "Private Channel",
    "emoji": "🔒",
    "username": "",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1002337293281": {
    "name": "Backup Channel 2",
    "emoji": "💾",
    "username": "",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1003614546520": {
    "name": "Forwarded Channel",
    "emoji": "🔄",
    "username": "",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1002831605258": {
    "name": "Threater Print",
    "emoji": "🎭",
    "username": "@threater_print_movies",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1002964109368": {
    "name": "ET Backup",
    "emoji": "📦",
    "username": "@ETBackup",
    "type": "movie",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  },
  "-1003083386043": {
    "name": "Request Group",
    "emoji": "💬",
    "username": "@EntertainmentTadka7860",
    "type": "request",
    "total_movies": 0,
    "last_movie": null,
    "last_updated": "'$(date -Iseconds)'",
    "created": "'$(date -Iseconds)'"
  }
}
EOF

# Create error log
touch error.log

# ============================================
# 🔐 SET FILE PERMISSIONS
# ============================================

echo "🔐 Setting file permissions..."

chmod 666 movies.csv users.json bot_stats.json channels_tracker.json error.log
chmod 777 backups logs data
chmod +x docker/startup.sh 2>/dev/null || true

# ============================================
# 📦 CREATE DOCKER CONFIG FILES
# ============================================

echo "🐳 Creating Docker configuration files..."

# Create docker directory if not exists
mkdir -p docker

# Create apache config
cat > docker/apache-config.conf << 'EOF'
<VirtualHost *:$PORT>
    ServerAdmin admin@entertainmenttadka.com
    DocumentRoot /var/www/html
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    
    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    LimitRequestBody 104857600
</VirtualHost>
EOF

# Create php config
cat > docker/php-config.ini << 'EOF'
display_errors = On
display_startup_errors = On
error_reporting = E_ALL
log_errors = On
error_log = /var/www/html/error.log

upload_max_filesize = 100M
post_max_size = 100M

max_execution_time = 300
memory_limit = 256M

date.timezone = "Asia/Kolkata"
EOF

# ============================================
# 📋 CREATE .ENV FILE (Optional)
# ============================================

echo "📋 Creating environment file..."

cat > .env.example << 'EOF'
# ============================================
# 🎬 ENTERTAINMENT TADKA BOT ENVIRONMENT
# ============================================

# Telegram Bot Configuration
BOT_TOKEN=8315381064:AAGk0FGVGmB8j5SjpBvW3rD3_kQHe_hyOWU
BOT_USERNAME=@EntertainmentTadkaBot

# Application Settings
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-app.onrender.com

# Render.com Settings
RENDER=1
PORT=10000

# Channel IDs (from your configuration)
MAIN_CHANNEL_ID=-1002831038104
REQUEST_GROUP_ID=-1003083386043

# Security
ADMIN_ID=