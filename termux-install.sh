#!/usr/bin/env bash

# Installation Script for Terminal Configurations
# This script symlinks dotfiles from this repo to the home directory.

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Array of files to symlink in the format: "source:target"
FILES_TO_LINK=(
    "zsh/.zshrc:.zshrc"
    "zsh/.p10k.zsh:.p10k.zsh"
)

# Set up SSH carefully to retain permissions
mkdir -p "$HOME_DIR/.ssh"
chmod 700 "$HOME_DIR/.ssh"

echo "Setting up symlinks..."

for entry in "${FILES_TO_LINK[@]}"; do
    src="${entry%%:*}"
    dest="${entry##*:}"
    
    src_path="$CONFIG_DIR/$src"
    dest_path="$HOME_DIR/$dest"

    # Backup existing file/symlink if it exists
    if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
        echo "Backing up existing $dest_path to $dest_path.backup"
        mv "$dest_path" "$dest_path.backup"
    fi

    # Create new symlink
    echo "Symlinking $src_path to $dest_path"
    ln -s "$src_path" "$dest_path"
done

# Copy SSH config instead of symlinking, to prevent strict permission issues with SSH
echo "Setting up SSH config..."
if [ -f "$HOME_DIR/.ssh/config" ]; then
    echo "Backing up existing ~/.ssh/config to ~/.ssh/config.backup"
    mv "$HOME_DIR/.ssh/config" "$HOME_DIR/.ssh/config.backup"
fi
cp "$CONFIG_DIR/ssh/config" "$HOME_DIR/.ssh/config"
chmod 600 "$HOME_DIR/.ssh/config"

echo "Updating and upgrading packages via pkg..."
if command -v pkg >/dev/null 2>&1; then
    pkg update -y
    pkg upgrade -y
else
    echo "pkg not found. Are you on Termux?"
fi

echo "Installation complete! Please restart your terminal."
