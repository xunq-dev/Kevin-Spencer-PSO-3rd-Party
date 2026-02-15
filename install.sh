#!/bin/bash
set -e

echo "===================================="
echo " Starting Pro Soccer Online Installer..."
echo "===================================="

########################################
# Install Homebrew (if not installed)
########################################
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."

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
    echo "Installing Rosetta..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license || true
fi

brew update

########################################
# Install Wine
########################################
echo "Installing Wine..."
brew install --cask --no-quarantine wine-stable || brew install wine

########################################
# Download File From Google Drive
########################################
FILEID="1ruGnqm_660ghSLC5EMQoQ2SEjhbuZeng"
ZIP_NAME="Pro Soccer Online.zip"

echo "Downloading Pro Soccer Online..."

TMP_COOKIE=$(mktemp)

curl -c "$TMP_COOKIE" \
  "https://drive.google.com/uc?export=download&id=${FILEID}" \
  -o response.html

CONFIRM=$(grep -o 'confirm=[^&]*' response.html | sed 's/confirm=//')

if [ -n "$CONFIRM" ]; then
    curl -Lb "$TMP_COOKIE" \
      "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILEID}" \
      -o "$ZIP_NAME"
else
    mv response.html "$ZIP_NAME"
fi

rm -f "$TMP_COOKIE"

########################################
# Extract ZIP
########################################
echo "Extracting..."
unzip -o "$ZIP_NAME"

########################################
# Move App to /Applications
########################################
APP_NAME="Pro Soccer Online.app"

if [ ! -d "$APP_NAME" ]; then
    echo "Error: $APP_NAME not found after extraction!"
    exit 1
fi

echo "Moving $APP_NAME to /Applications..."
sudo mv "$APP_NAME" /Applications/

########################################
# Cleanup
########################################
rm -f "$ZIP_NAME"

echo "===================================="
echo " Install complete!"
echo " Sign into Steam, download PSO and it will work!"
echo "===================================="
