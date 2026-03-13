#!/usr/bin/env bash

# This script automates setting up passwordless SSH to a Termux instance.
# It reads the connection string and password, and uses 'expect' to push
# the local Mac's public SSH key to the Termux device.

if ! command -v expect >/dev/null 2>&1; then
    echo "Error: 'expect' is required but not installed."
    echo "You can install it using Homebrew: brew install expect"
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <termux_ip> <password> [port (default: 8022)]"
    echo "Example: $0 192.168.1.6 MySecretPassword"
    exit 1
fi

TERMUX_IP=$1
PASSWORD=$2
PORT=${3:-8022}

# Automatically find a public key (prefer ed25519, fallback to rsa)
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    PUBKEY=$(cat "$HOME/.ssh/id_ed25519.pub")
elif [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    PUBKEY=$(cat "$HOME/.ssh/id_rsa.pub")
else
    echo "Error: Could not find a public SSH key in ~/.ssh/"
    echo "Generate one using: ssh-keygen -t ed25519"
    exit 1
fi

echo "Setting up passwordless SSH to $TERMUX_IP:$PORT..."

# Create a temporary expect script
EXPECT_SCRIPT=$(mktemp /tmp/setup_termux_ssh.XXXXXX.exp)

cat << EOF > "$EXPECT_SCRIPT"
#!/usr/bin/expect -f
set timeout 10
set pass "$PASSWORD"
set pubkey "$PUBKEY"

spawn ssh -o StrictHostKeyChecking=accept-new -p $PORT $TERMUX_IP "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '\$pubkey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

expect {
    "password:" {
        send "\$pass\r"
        exp_continue
    }
    eof
}
EOF

# Run the expect script
expect "$EXPECT_SCRIPT"
RESULT=$?

# Clean up
rm -f "$EXPECT_SCRIPT"

if [ $RESULT -eq 0 ]; then
    echo "✅ Successfully set up passwordless SSH!"
    echo "You can now connect using: ssh -p $PORT $TERMUX_IP"
else
    echo "❌ Failed to set up passwordless SSH. Check your password and connection."
fi
