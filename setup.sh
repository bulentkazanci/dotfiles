#!/bin/bash

# Check if Homebrew is installed
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew
brew update

# Install all our dependencies with bundle (See Brewfile)
echo "=====> Installing homebrew bundle"
brew tap homebrew/bundle
brew bundle

# ==============
#   Directories
# ==============
echo "====> Creating essential folders"
if [ ! -d "$HOME/Brkdev" ] 
then
  mkdir $HOME/Brkdev
fi


# ==============
#  VIM Plugins
# ==============
VIM_PLUG_FILE="${HOME}/.vim/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "${HOME}/.vim/plugged"
  pushd "${HOME}/.vim/plugged"
  git clone https://github.com/preservim/nerdtree.git
  git clone https://github.com/tpope/vim-surround.git
  git clone https://github.com/vim-airline/vim-airline.git
  git clone https://github.com/tomasr/molokai.git
  git clone "https://github.com/ervandew/supertab"
  git clone git://github.com/SirVer/ultisnips.git
  git clone git://github.com/honza/vim-snippets.git
  git clone "https://github.com/Raimondi/delimitMate"
  git clone "https://github.com/tpope/vim-markdown.git"
  git clone "https://github.com/plasticboy/vim-markdown"
  git clone "https://github.com/fatih/vim-go"
  git clone "https://github.com/elzr/vim-json"
  git clone "https://github.com/ekalinin/Dockerfile.vim"
  git clone "https://github.com/junegunn/fzf.vim"
  popd
fi


# ==============
#   oh-my-zsh
# ==============
echo " [+] Installing the oh-my-zsh... " 
curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh install.sh --unattended
rm install.sh


# ==============
#   zsh plugins
# ==============
if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/bhilburn/powerlevel9k.git "${HOME}/.zsh/powerlevel9k"
fi

# ==============
#   fzf
# ==============
if [ ! -d "${HOME}/.fzf" ]; then
  echo " ==> Installing fzf"
  git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
  pushd "${HOME}/.fzf"
  git remote set-url origin git@github.com:junegunn/fzf.git 
  ${HOME}/.fzf/install --bin --64 --no-bash --no-zsh --no-fish
  popd
fi

# ==============
#   VSCODE
# ==============
echo " [+] Installing VSCODE extensions... "
code --install-extension ms-vscode.Go 
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
