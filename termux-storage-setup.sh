#!/usr/bin/env bash

# termux-storage-setup.sh
# Automates the request for Android storage permissions and sets up symlinks

echo "Requesting Android storage permissions..."
termux-setup-storage

echo "Storage setup complete. You may be prompted by Android to grant permissions."
echo "Symlinks to your internal storage, DCIM, and Downloads have been created in ~/storage"
