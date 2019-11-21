#!/bin/bash

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