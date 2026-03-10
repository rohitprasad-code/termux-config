# Auto-Start SSH Daemon on App Launch
# To enable this, add the following snippet to the END of your zsh/.zshrc file
# or at the end of ~/.zshrc directly on your phone.

# --- Auto-Start SSH Daemon ---
# Checks if sshd is running. If not, starts it silently.
if ! pgrep -x "sshd" > /dev/null; then
    sshd
fi
# -----------------------------
