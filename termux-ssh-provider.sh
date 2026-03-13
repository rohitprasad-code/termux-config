#!/usr/bin/env bash

# This script generates the SSH command you need to paste into your Mac to connect to this Termux instance.

# Ensure sshd is running
if ! pgrep -x "sshd" > /dev/null; then
    echo "Starting sshd..."
    sshd
fi

# Get the current username
USER=$(whoami)

# Get the primary IP address (searches all interfaces for the first non-localhost IPv4 address)
IP=$(ifconfig 2>/dev/null | grep -w inet | awk '{print $2}' | sed 's/addr://' | grep -v '127.0.0.1' | head -n 1)

if [ -z "$IP" ]; then
    echo "Could not find a valid IP address. Are you connected to Wi-Fi?"
    echo "Fallback command (replace your_ip): ssh -p 8022 ${USER}@your_ip"
else
    COMMAND="ssh -p 8022 ${USER}@${IP}"
    echo "========================================================="
    echo "Copy and paste the command into your Mac's terminal"
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
