#!/usr/bin/env bash

# This script generates the SSH command you need to paste into your Mac
# to connect to this Termux instance.

# Ensure sshd is running
if ! pgrep -x "sshd" > /dev/null; then
    echo "Starting sshd..."
    sshd
fi

# Get the current username
USER=$(whoami)

# Get the primary IP address (looking for the wlan0 inet address)
IP=$(ifconfig wlan0 | grep -o 'inet addr:[0-9.]*' | awk -F: '{print $2}')

# Fallback if wlan0 fails (e.g. some modern Android versions might format `ip a` differently)
if [ -z "$IP" ]; then
    IP=$(ip -4 addr show wlan0 2>/dev/null | grep -oE 'inet (addr:)?([0-9.]+)' | awk '{print $2}' )
fi

if [ -z "$IP" ]; then
    echo "Could not find a valid IP address for wlan0. Are you connected to Wi-Fi?"
    echo "Fallback command (replace your_ip): ssh -p 8022 ${USER}@your_ip"
else
    COMMAND="ssh -p 8022 ${USER}@${IP}"
    echo "========================================================="
    echo "Copy and paste the following command into your Mac's terminal:"
    echo "========================================================="
    echo ""
    echo "$COMMAND"
    echo ""
    echo "========================================================="
    
    # Try to copy to clipboard if termux-api is installed
    if command -v termux-clipboard-set >/dev/null 2>&1; then
        echo -n "$COMMAND" | termux-clipboard-set
        echo "✅ The command has been copied to your Android clipboard!"
    else
        echo "💡 Tip: Install 'termux-api' to automatically copy this to your clipboard."
        echo "   Run: pkg install termux-api"
    fi
fi
