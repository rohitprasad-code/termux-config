#!/usr/bin/env bash

# send-mac.sh
# Quickly transfer files from your phone to your Mac's Desktop

MAC_IP="192.168.1.50" # Replace with your Mac's IP
MAC_USER="rohitprasad" # Replace with your Mac's username
DEST_DIR="Desktop" # Change if you want to send elsewhere (e.g., Downloads)

if [ -z "$1" ]; then
    echo "Usage: ./send-mac.sh <file_to_send>"
    exit 1
fi

FILE="$1"

if [ ! -e "$FILE" ]; then
    echo "Error: File '$FILE' does not exist."
    exit 1
fi

echo "Sending '$FILE' to $MAC_USER@$MAC_IP:~/$DEST_DIR"
scp "$FILE" "$MAC_USER@$MAC_IP:~/$DEST_DIR"

if [ $? -eq 0 ]; then
    echo "✅ Success!"
else
    echo "❌ Transfer failed. Check if SSH is running on your Mac and the IPs match."
fi
