#!/usr/bin/env bash

# termux-restore-packages.sh
# Restores installed packages from a backup text file

RESTORE_FILE="${1:-packages.txt}"

if [ ! -f "$RESTORE_FILE" ]; then
    echo "Error: Backup file '$RESTORE_FILE' not found!"
    echo "Usage: ./termux-restore-packages.sh [path/to/packages.txt]"
    exit 1
fi

echo "Updating package lists..."
pkg update -y

echo "Restoring packages from $RESTORE_FILE..."
# Read the file and install all packages
xargs -a "$RESTORE_FILE" pkg install -y

echo "Package restoration complete!"
