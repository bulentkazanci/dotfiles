set -gxp PATH $HOME/go/bin /usr/local/opt/python@3.11/libexec/bin /usr/local/sbin /opt/homebrew/bin /opt/homebrew/opt/node@20/bin
set -gx GOBIN $HOME/go/bin
set -gx EDITOR nvim
set -gx FZF_CTRL_T_COMMAND nvim

# Load local fish config
if test -f ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end

# Disable fish greeting
set fish_greeting ""


# ==============
#   General
# ==============
alias e="exit"
alias cls="clear"

# ==============
#   Git
# ==============
alias gs="git status"
alias gpl="git pull"
alias gps="git push -f"
alias gc="git add . && git commit -am "
alias gcf="git add . && git commit -m 'f'"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate --all -n 10"
alias gcm="git checkout master"
alias gr="git rebase -i HEAD~2"
alias gr3="git rebase -i HEAD~3"
alias gr4="git rebase -i HEAD~4"
alias gr5="git rebase -i HEAD~5"

# ==============
#   Tmux
# ==============
alias tmn="tmux new -s"
alias tma="tmux attach -t"
alias tmls="tmux ls"
alias tmk="tmux kill-session -t"

# ===================
#   Vim Mode in Fish
# ===================
fish_vi_key_bindings
