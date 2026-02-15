#!/bin/bash
set -e

echo "===================================="
echo " Starting Pro Soccer Online Installer..."
echo "===================================="

########################################
# Install Homebrew (if not installed)
########################################
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew…"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH automatically
    if [[ -d "/opt/homebrew/bin" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

########################################
# Install Rosetta (Apple Silicon only)
########################################
if [[ $(uname -m) == "arm64" ]]; then
    echo "Installing Rosetta (if needed)…"
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license || true
fi

brew update

########################################
# Install Wine
########################################
echo "Installing Wine…"
brew install --cask --no-quarantine wine-stable || brew install wine

########################################
# Download Pro Soccer Online.zip from MediaFire
########################################
ZIP_NAME="Pro Soccer Online.zip"
MEDIAFIRE_URL="https://download1472.mediafire.com/wm6ewfgc2hag87VGvcB2xeXffePH0kewjmqai05p2gfgLOoOytYWlaWAG65e1zYH_jquVXKBTiQT6ASq_xdoWZyfsM8XIH2h28m29jMD5CTv_k9jcdwl4z6nqPT4Gwd-EUVJSmAg3kB-DCLdWre-VsFJvQiLmqOwHC9tWCDvRcrQ/ddgqg3nk7k7iwst/Pro+Soccer+Online.zip"

echo "Downloading Pro Soccer Online (2.4GB)…"

curl -L -C - -o "$ZIP_NAME" "$MEDIAFIRE_URL"

########################################
# Extract ZIP
########################################
echo "Extracting…"
unzip -o "$ZIP_NAME"

########################################
# Move App to /Applications
########################################
APP_NAME="Pro Soccer Online.app"

if [ ! -d "$APP_NAME" ]; then
    echo "Error: $APP_NAME not found after extraction!"
    exit 1
fi

echo "Moving $APP_NAME to /Applications…"
sudo mv "$APP_NAME" /Applications/

########################################
# Cleanup
########################################
rm -f "$ZIP_NAME"

echo "===================================="
echo " Install complete!"
echo " Run 'Pro Soccer Online' from your Applications folder, sign into Steam, and download PSO — it will work!"
echo "===================================="
