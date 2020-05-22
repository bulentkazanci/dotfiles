#!/bin/bash

# Check if Homebrew is installed
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# ==============
#   Directories
# ==============
if [ ! -d "$HOME/Brkdev" ] 
then
  mkdir $HOME/Brkdev
fi


# ==============
#   oh-my-zsh
# ==============
echo " [+] Installing the oh-my-zsh... " 
curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh install.sh --unattended
rm install.sh


# ==============
#   VSCODE
# ==============
echo " [+] Installing VSCODE extensions... "
code --install-extension ms-vscode.Go 
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
