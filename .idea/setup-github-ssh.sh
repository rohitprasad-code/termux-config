#!/usr/bin/env bash

# GitHub SSH Key Setup
# Automatically generates an SSH key and prints it so you can add it to Github

EMAIL="your-email@example.com" # Change this

echo "Generating new SSH key for GitHub..."
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519_github -N ""

echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

echo "Adding key to ssh-agent..."
ssh-add ~/.ssh/id_ed25519_github

echo "======================================"
echo "Here is your public key:"
echo "======================================"
cat ~/.ssh/id_ed25519_github.pub
echo "======================================"

if command -v termux-clipboard-set >/dev/null 2>&1; then
    cat ~/.ssh/id_ed25519_github.pub | termux-clipboard-set
    echo "✅ Key copied to your Android clipboard!"
fi

echo "Go to https://github.com/settings/keys and paste this key as a New SSH Key."
