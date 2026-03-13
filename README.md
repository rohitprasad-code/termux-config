# Termux Configuration

This repository contains terminal configuration files, including ZSH, Powerlevel10k, and SSH settings specifically tailored for **Termux on Android**.

## Prerequisites

Before running the installation, ensure you have the required packages installed in Termux:

```bash
pkg update && pkg upgrade
pkg install zsh git curl openssh termux-api
```

## Setup Instructions

Simply run the installation script from this directory to symlink these dotfiles into your Termux home directory (`~`).

```bash
./termux-install.sh
```

### Zsh & Powerlevel10k

The installation assumes you have [Oh My Zsh](https://ohmyz.sh/) installed.
If not, install it via:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

To install the Powerlevel10k theme:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Change your default shell to Zsh (Termux-specific fix if `chsh` gives issues):

```bash
chsh -s zsh
```

After installation, restarting your terminal should load the new configuration. You can reconfigure Powerlevel10k anytime by running `p10k configure`.

### SSH Setup

The included `ssh/config` contains a template for connecting **from your phone** to another device (like your Mac or GitHub).
You will need to generate an SSH key on your phone and copy the public key to the remote server.

```bash
# Generate a new SSH key
ssh-keygen -t rsa -b 4096

# Show your public key so you can copy it to your Mac's ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub
```

### Connecting to Termux from outside

If you need to SSH _into_ your phone from your Mac, Termux runs its SSH daemon on port 8022.
To easily find your connection command, I have included helper scripts:

**Option 1: Direct SSH Command**

```bash
# On your phone in Termux, run:
./termux-ssh.sh

# This will automatically start sshd and generate a string like:
# ssh -p 8022 u0_a123@192.168.1.50
```

Simply copy and paste that generated command into your Mac to connect.

**Option 2: SSH Config Block (Recommended)**

```bash
# On your phone in Termux, run:
./termux-ssh-config.sh
```

This will generate the exact configuration block for your phone (e.g. `Host u0_a123`, `HostName 192.168.1.50`, `Port 8022`). You can copy and paste this block directly into your Mac's `~/.ssh/config` file. Once saved, you can connect from your Mac instantly by just typing `ssh u0_a123`.

You must also run `passwd` on your phone first to create a password if you aren't using keys.

**(New) Option 3: Automated Passwordless SSH (Mac to Termux)**

To completely automate logging in without a password, use the included setup script from your Mac terminal:

```bash
# On your Mac, run:
./termux-ssh-trusted.sh <termux_ip> <password>
```

This script will automatically copy your Mac's public SSH key into Termux's `authorized_keys` file, allowing seamless, passwordless logins moving forward.

_(Note: If you want to connect TO Termux from your Mac, run `sshd` in Termux to start the server on port 8022.)_

### VS Code / Antigravity Remote SSH Native Fix

Out of the box, VS Code / Antigravity Remote SSH will **fail** to connect to Termux with an `"unexpected e_type: 2"` error. This is because the editor tries to download a standard Linux (glibc) version of Node.js to run its backend server, which Android natively rejects.

Additionally, once connected, the **integrated terminal won't work** because Termux uses non-standard shell paths (e.g., `/data/data/com.termux/files/usr/bin/zsh` instead of `/bin/zsh`).

To fix **both issues**, we have provided an automated script:

1. On your Mac, try to connect to Termux via your editor's "Remote SSH" connection AT LEAST ONCE. It will inevitably fail. **This is expected!** It needs to fail so that it leaves its downloaded server files on your phone.
2. Go back to your phone (via terminal SSH or natively) and run the patch script:
   ```bash
   ./termux-antigravity-patch.sh
   ```
3. The script will:
   - Find the broken server and swap in Termux's native `nodejs`
   - **Configure the integrated terminal** to use your Termux shell (auto-detected)
4. Try to connect from your Mac again. The editor will connect and the terminal will work!

_(Note: Every time your editor gets an app update, it will download a new server, and you will need to repeat this process.)_
