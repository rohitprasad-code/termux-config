#!/usr/bin/env bash

# This script generates an SSH config block tailored for your phone.
# You can copy and paste this directly into your Mac's ~/.ssh/config

if ! pgrep -x "sshd" > /dev/null; then
    echo "Starting sshd..."
    sshd
fi

USER=$(whoami)
IP=$(ifconfig 2>/dev/null | grep -w inet | awk '{print $2}' | sed 's/addr://' | grep -v '127.0.0.1' | head -n 1)

if [ -z "$IP" ]; then
    IP="[YOUR_PHONE_IP]"
fi

# We use the username as the Host alias, just like your ~/.ssh/config example,
# or you can change this to "1plus" as in your template.
HOST_ALIAS="$USER"

CONFIG_BLOCK="Host $HOST_ALIAS
    HostName $IP
    Port 8022
    User $USER
    IdentityFile ~/.ssh/id_rsa"

echo "========================================================="
echo "Add the following block to your Mac's ~/.ssh/config file:"
echo "========================================================="
echo ""
echo "$CONFIG_BLOCK"
echo ""
echo "========================================================="
echo "Then, you can connect from your Mac simply by typing:"
echo "ssh $HOST_ALIAS"
echo "========================================================="

# Copy to clipboard if termux-api is available
if command -v termux-clipboard-set >/dev/null 2>&1; then
    echo -n "$CONFIG_BLOCK" | termux-clipboard-set
    echo "✅ This config block has been copied to your Android clipboard!"
fi

# Write the config block to a file
echo "$CONFIG_BLOCK" > ~/.ssh/config
