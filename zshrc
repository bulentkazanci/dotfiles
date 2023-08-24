export ZSH="/Users/Brk/.oh-my-zsh"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh


# ==============
#   Plugins
# ==============
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/powerlevel9k/powerlevel9k.zsh-theme


# ==============
#   Git
# ==============
alias gs="git status"
alias gpl="git pull"
alias gps="git push -f"
alias gc="git add . && git commit -m 'f'"
alias gd="git diff"
alias gr="git rebase -i HEAD~2"
alias gr3="git rebase -i HEAD~3"
alias gr4="git rebase -i HEAD~4"
alias gr5="git rebase -i HEAD~5"
