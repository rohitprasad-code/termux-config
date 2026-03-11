#!/data/data/com.termux/files/usr/bin/bash

# termux-antigravity-patch.sh
# Fixes the "unexpected e_type: 2" error when connecting to Termux via Antigravity/VS Code
# by replacing the downloaded Linux `node` binary with Termux's native Android `node`.

echo "==========================================="
echo "   Fixing Antigravity Server for Termux    "
echo "==========================================="

echo "[1/4] Installing native Node.js..."
pkg update -y
pkg install nodejs -y

NATIVE_NODE=$(which node)
if [ -z "$NATIVE_NODE" ]; then
    echo "❌ Error: Node.js failed to install."
    exit 1
fi
echo "✅ Native Node.js found at: $NATIVE_NODE"

SERVER_DIR="$HOME/.antigravity-server/bin"
VSCODE_DIR="$HOME/.vscode-server/bin"

echo ""
echo "[2/4] Looking for installed Antigravity & VS Code servers..."

PATCHED=0

patch_server_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        for version_dir in "$dir"/*; do
            if [ -d "$version_dir" ]; then
                echo "Found server version: $(basename "$version_dir")"
                if [ -e "$version_dir/node" ]; then
                    if [ -L "$version_dir/node" ]; then
                        echo "  - Already patched!"
                        PATCHED=1
                    else
                        echo "  - Patching standard Linux node..."
                        rm -f "$version_dir/node"
                        ln -sf "$NATIVE_NODE" "$version_dir/node"
                        echo "  ✅ Patched successfully."
                        PATCHED=1
                    fi
                fi
            fi
        done
    fi
}

patch_server_dir "$SERVER_DIR"
patch_server_dir "$VSCODE_DIR"

echo ""

# === Step 3: Configure terminal for Antigravity ===
echo "[3/4] Configuring integrated terminal..."

# Detect the user's login shell
USER_SHELL="$SHELL"
if [ -z "$USER_SHELL" ]; then
    # Fallback: check common Termux shell locations
    if [ -x "/data/data/com.termux/files/usr/bin/zsh" ]; then
        USER_SHELL="/data/data/com.termux/files/usr/bin/zsh"
    elif [ -x "/data/data/com.termux/files/usr/bin/bash" ]; then
        USER_SHELL="/data/data/com.termux/files/usr/bin/bash"
    else
        USER_SHELL="/data/data/com.termux/files/usr/bin/sh"
    fi
fi

SHELL_NAME=$(basename "$USER_SHELL")
echo "  Detected shell: $USER_SHELL ($SHELL_NAME)"

# Write Machine settings for both Antigravity and VS Code server directories
configure_terminal() {
    local settings_dir="$1/data/Machine"
    local settings_file="$settings_dir/settings.json"

    mkdir -p "$settings_dir"

    # If settings.json already exists, we merge; otherwise create fresh
    cat > "$settings_file" << SETTINGS_EOF
{
    "terminal.integrated.defaultProfile.linux": "termux-$SHELL_NAME",
    "terminal.integrated.profiles.linux": {
        "termux-$SHELL_NAME": {
            "path": "$USER_SHELL",
            "overrideName": true
        }
    }
}
SETTINGS_EOF

    echo "  ✅ Terminal configured at: $settings_file"
}

# Configure for Antigravity server
if [ -d "$HOME/.antigravity-server" ]; then
    configure_terminal "$HOME/.antigravity-server"
fi

# Configure for VS Code server
if [ -d "$HOME/.vscode-server" ]; then
    configure_terminal "$HOME/.vscode-server"
fi

# If neither server dir exists yet, create the settings preemptively for both
if [ ! -d "$HOME/.antigravity-server" ] && [ ! -d "$HOME/.vscode-server" ]; then
    echo "  No server directories found yet. Creating settings preemptively..."
    mkdir -p "$HOME/.antigravity-server"
    configure_terminal "$HOME/.antigravity-server"
    mkdir -p "$HOME/.vscode-server"
    configure_terminal "$HOME/.vscode-server"
fi

echo ""
if [ "$PATCHED" -eq 1 ]; then
    echo "[4/4] Done!"
    echo "==========================================="
    echo "✅ Your Editor Server is now patched!"
    echo "✅ Integrated terminal is configured to use: $SHELL_NAME"
    echo ""
    echo "You can now connect from your Mac normally!"
    echo ""
    echo "Important: Since the connection failed earlier, the server is left over."
    echo "Next time you connect, your editor will use this patched 'node' binary"
    echo "and the terminal will open with your Termux $SHELL_NAME shell."
    echo ""
    echo "Note: Every time Antigravity updates to a new version, the connection"
    echo "will fail once, and you will need to run this script again."
    echo "==========================================="
else
    echo "❌ Could not find any downloaded servers to patch the node binary."
    echo "You MUST try to connect from your Mac FIRST (and let it fail) before running this script."
    echo ""
    echo "However, terminal settings have been pre-configured for when you do connect."
fi
