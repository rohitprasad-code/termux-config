#!/usr/bin/env bash

# termux-ssh-keygen.sh
# Quickly generates a new SSH key and prints the public key for copying
# Usage: ./termux-ssh-keygen.sh

KEY_PATH="$HOME/.ssh/id_rsa"
COMMENT="termux@$(date +%Y-%m-%d)"

if [ -f "$KEY_PATH" ]; then
    echo "An SSH key already exists at $KEY_PATH."
else
    echo "Generating new RSA SSH Key..."
    # Generate the key with no passphrase for automation (or prompt if preferred)
    ssh-keygen -t rsa -b 4096 -C "$COMMENT" -N "" -f "$KEY_PATH"
    echo "Key successfully generated!"
fi

echo ""
echo "================= YOUR PUBLIC SSH KEY ================="
cat "$KEY_PATH.pub"
echo "======================================================="
echo ""
echo "Copy the block above and paste it into the ~/.ssh/authorized_keys file of the server you want to connect to."
