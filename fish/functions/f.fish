function f -d "Fuzzy-find and open a file in current directory"
  nvim (fzf --height 100% --info inline --border --reverse --preview 'bat --color=always {}')
end
