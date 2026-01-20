#!/bin/bash
# ============================================
# 🛠️ SETUP SCRIPT FOR ENTERTAINMENT TADKA BOT
# Simplified Version
# ============================================

set -e

echo "============================================"
echo "🛠️  SETUP: ENTERTAINMENT TADKA BOT"
echo "============================================"

# ============================================
# 📁 CREATE DIRECTORIES
# ============================================

echo "📁 Creating directories..."
mkdir -p backups logs data

# ============================================
# 📄 CREATE REQUIRED FILES
# ============================================

echo "📄 Creating required files..."

# Create empty CSV with headers
echo "movie_name,message_id,date,channel_id,channel_name,channel_emoji,added_timestamp" > movies.csv

# Create empty JSON files
echo '{"users": {}, "total_requests": 0, "message_logs": [], "created": "'$(date -Iseconds)'"}' > users.json
echo '{"total_movies": 0, "total_users": 0, "total_searches": 0, "channels_stats": {}, "last_updated": "'$(date -Iseconds)'", "created": "'$(date -Iseconds)'"}' > bot_stats.json

# Create channels tracker
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

# ============================================
# ✅ COMPLETION MESSAGE
# ============================================

echo "============================================"
echo "✅ SETUP COMPLETED SUCCESSFULLY!"
echo "============================================"
echo ""
echo "📁 Files created:"
echo "  • movies.csv (with headers)"
echo "  • users.json (empty structure)"
echo "  • bot_stats.json (empty stats)"
echo "  • channels_tracker.json (your channels)"
echo "  • error.log (empty)"
echo ""
echo "🚀
