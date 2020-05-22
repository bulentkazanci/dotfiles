export ZSH="/Users/Brk/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ==============
#   Git
# ==============
alias gs="git status"
alias gpl="git pull"
alias gps="git push -f"
alias gc="git add . && git commit -m 'f'"
alias gd="git diff"
alias gr="git rebase -i HEAD~2"
