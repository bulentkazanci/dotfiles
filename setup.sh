#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "====> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH (especially important on Apple Silicon)
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed"
fi

# Update Homebrew
brew update
brew upgrade

# Install all our dependencies with bundle (See Brewfile)
echo "=====> Installing homebrew bundle"
brew bundle

# ==============
#   Directories
# ==============
echo "====> Creating essential folders"
if [ ! -d "$HOME/Brkdev" ] 
then
  mkdir $HOME/Brkdev
fi

# ============================
#   Install Chrome Extension
# ============================
echo "====> Installing Chrome extensions"
CHROME_EXTENSION_DIR="$HOME/Library/Application Support/Google/Chrome/External Extensions"
if [ ! -d "$CHROME_EXTENSION_DIR" ]; then
  mkdir -p "$CHROME_EXTENSION_DIR"
fi


VIMIUM_EXTENSION_ID="dbepggeogbaibhgnhhndojpepiihcmeb"

cat <<EOF > "$CHROME_EXTENSION_DIR/$VIMIUM_EXTENSION_ID.json"
{
  "external_update_url": "https://clients2.google.com/service/update2/crx"
}
EOF

