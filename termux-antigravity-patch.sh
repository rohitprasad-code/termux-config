#!/data/data/com.termux/files/usr/bin/bash

# termux-antigravity-patch.sh
# Fixes the "unexpected e_type: 2" error when connecting to Termux via Antigravity/VS Code
# by replacing the downloaded Linux `node` binary with Termux's native Android `node`.

echo "==========================================="
echo "   Fixing Antigravity Server for Termux    "
echo "==========================================="

echo "[1/3] Installing native Node.js..."
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
echo "[2/3] Looking for installed Antigravity & VS Code servers..."

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
if [ "$PATCHED" -eq 1 ]; then
    echo "[3/3] Done!"
    echo "==========================================="
    echo "✅ Your Editor Server is now patched!"
    echo "You can now connect from your Mac normally!"
    echo ""
    echo "Important: Since the connection failed earlier, the server is left over."
    echo "Next time you connect, your editor will use this patched 'node' binary."
    echo "Note: Every time Antigravity updates to a new version, the connection"
    echo "will fail once, and you will need to run this script again."
    echo "==========================================="
else
    echo "❌ Could not find any downloaded servers."
    echo "You MUST try to connect from your Mac FIRST (and let it fail) before running this script."
fi
