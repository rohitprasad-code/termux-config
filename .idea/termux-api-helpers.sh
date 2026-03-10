# Termux:API Scripts & Snippets
# Requires: pkg install termux-api and the Termux:API app installed from F-Droid

# Useful aliases to add to your zshrc:

# Check battery status
alias battery='termux-battery-status | grep -E "percentage|status" | tr -d "\", "'

# Share text or file to another app (e.g., WhatsApp, Email)
alias share='termux-share'

# Example usage of share:
# echo "Check out this link: https://google.com" | share
# share my_photo.jpg 
