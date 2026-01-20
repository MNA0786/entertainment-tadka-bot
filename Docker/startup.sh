#!/bin/bash
# ============================================
# 🚀 STARTUP SCRIPT FOR ENTERTAINMENT TADKA BOT
# Render.com Compatible
# ============================================

echo "============================================"
echo "🎬 ENTERTAINMENT TADKA BOT - Starting..."
echo "============================================"

# ============================================
# 📁 SETUP DIRECTORIES
# ============================================

echo "📂 Setting up directories..."

# Create required directories
mkdir -p /var/www/html/backups
mkdir -p /var/www/html/logs
mkdir -p /var/www/html/data

# Set permissions
chmod 777 /var/www/html/backups
chmod 777 /var/www/html/logs
chmod 777 /var/www/html/data

# ============================================
# 📝 CHECK REQUIRED FILES
# ============================================

echo "📄 Checking required files..."

# Create required files if they don't exist
if [ ! -f "/var/www/html/movies.csv" ]; then
    echo "movie_name,message_id,date,channel_id,channel_name,channel_emoji,added_timestamp" > /var/www/html/movies.csv
    echo "✅ Created movies.csv"
fi

if [ ! -f "/var/www/html/users.json" ]; then
    echo '{"users": {}, "total_requests": 0, "message_logs": [], "created": "'$(date -Iseconds)'"}' > /var/www/html/users.json
    echo "✅ Created users.json"
fi

if [ ! -f "/var/www/html/bot_stats.json" ]; then
    echo '{"total_movies": 0, "total_users": 0, "total_searches": 0, "channels_stats": {}, "last_updated": "'$(date -Iseconds)'", "created": "'$(date -Iseconds)'"}' > /var/www/html/bot_stats.json
    echo "✅ Created bot_stats.json"
fi

if [ ! -f "/var/www/html/channels_tracker.json" ]; then
    echo '{}' > /var/www/html/channels_tracker.json
    echo "✅ Created channels_tracker.json"
fi

if [ ! -f "/var/www/html/error.log" ]; then
    touch /var/www/html/error.log
    echo "✅ Created error.log"
fi

# Set file permissions
chmod 666 /var/www/html/*.csv /var/www/html/*.json /var/www/html/*.log 2>/dev/null || true

# ============================================
# 🔐 CHECK ENVIRONMENT VARIABLES
# ============================================

echo "🔐 Checking environment variables..."

if [ -z "$BOT_TOKEN" ]; then
    echo "❌ ERROR: BOT_TOKEN environment variable is not set!"
    echo "💡 Please set BOT_TOKEN in Render.com dashboard"
    exit 1
else
    echo "✅ BOT_TOKEN is set"
fi

# ============================================
# 🛠️ PRE-STARTUP CHECKS
# ============================================

echo "🛠️ Running pre-startup checks..."

# Check if port is set
if [ -z "$PORT" ]; then
    PORT=80
    echo "⚠️ PORT not set, defaulting to 80"
else
    echo "✅ PORT is set to $PORT"
fi

# Update Apache port in config
sed -i "s/\$PORT/$PORT/g" /etc/apache2/sites-available/000-default.conf
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf

# ============================================
# 📊 SYSTEM INFORMATION
# ============================================

echo "📊 System Information:"
echo "  🐳 Container: $(hostname)"
echo "  📅 Date: $(date)"
echo "  🖥️  PHP: $(php -v | head -n1)"
echo "  🌐 Apache: $(apache2 -v | grep version | cut -d' ' -f3-4)"
echo "  📁 Working Dir: $(pwd)"
echo "  🔧 BOT_TOKEN: ${BOT_TOKEN:0:10}..."

# ============================================
# 🚀 START APACHE
# ============================================

echo "============================================"
echo "🚀 Starting Apache server on port $PORT..."
echo "============================================"

# Start Apache in foreground
exec apache2-foreground