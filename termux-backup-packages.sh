#!/usr/bin/env bash

# termux-backup-packages.sh
# Backs up a list of currently installed packages to a text file

BACKUP_FILE="${1:-packages.txt}"

echo "Backing up installed packages to $BACKUP_FILE..."

# pkg list-installed outputs lines like: package-name/version architecture
# We use awk to grab just the package name, and tail to skip the header line
pkg list-installed | awk -F '/' '{print $1}' | tail -n +2 > "$BACKUP_FILE"

echo "Backup complete! Total packages backed up: $(wc -l < "$BACKUP_FILE" | tr -d ' ')"
