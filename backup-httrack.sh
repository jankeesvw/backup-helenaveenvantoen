#!/bin/bash

# Helena Ven van Toen Website Backup Script met HTTrack
# HTTrack is veel beter voor complete website backups

set -e

WEBSITE_URL="https://www.helenaveenvantoen.nl"
BACKUP_DIR="helenaveenvantoen.nl"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S")

echo "🌐 Starting backup of $WEBSITE_URL with HTTrack at $TIMESTAMP UTC"

# Check if httrack is installed
if ! command -v httrack &> /dev/null; then
    echo "❌ HTTrack is not installed"
    echo "📦 Install with: brew install httrack (macOS) or apt install httrack (Ubuntu)"
    exit 1
fi

# Remove old backup if it exists
if [ -d "$BACKUP_DIR" ]; then
    echo "🗑️  Removing old backup directory..."
    rm -rf "$BACKUP_DIR"
fi

# Create backup with HTTrack
echo "📥 Downloading website with HTTrack..."
httrack "$WEBSITE_URL" \
    -O "$BACKUP_DIR" \
    -r6 \
    -s0 \
    -I0 \
    -K3 \
    -c4 \
    -A25000 \
    -F "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    -*.css.map \
    -*.js.map \
    --disable-security-limits \
    --robots=0 \
    --ext-depth=2 \
    --near \
    "+images.squarespace-cdn.com/*" \
    "+static1.squarespace.com/*" \
    "+*.jpg" \
    "+*.jpeg" \
    "+*.png" \
    "+*.gif" \
    "+*.webp" \
    "-assets.squarespace.com/universal/*" \
    "-use.typekit.net/*" \
    "-p.typekit.net/*" \
    "-*.facebook.com/*" \
    "-fonts.googleapis.com/*" \
    "-fonts.gstatic.com/*"

# Check if backup was successful
if [ -d "$BACKUP_DIR" ]; then
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    echo "✅ Backup completed successfully!"
    echo "📊 Backup size: $BACKUP_SIZE"
    echo "📂 Location: ./$BACKUP_DIR"
else
    echo "❌ Backup failed - directory not found"
    exit 1
fi

# Optional: Check if this is a git repository and commit changes
if [ -d ".git" ]; then
    echo "🔍 Checking for changes in git repository..."
    
    git add "$BACKUP_DIR"
    
    if git diff --staged --quiet; then
        echo "ℹ️  No changes detected - backup is identical to previous version"
    else
        echo "📝 Changes detected - committing backup..."
        git commit -m "HTTrack backup $TIMESTAMP"
        echo "✅ Backup committed to git"
    fi
else
    echo "ℹ️  Not a git repository - backup saved locally only"
fi

echo "🎉 Backup process completed at $(date -u +"%Y-%m-%d %H:%M:%S") UTC"