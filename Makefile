install:
	@./setup.sh

copy:
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/ghostty

	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/config.fish ~/.config/fish/config.fish
	[ -d ~/.config/fish/functions/ ] || ln -s $(PWD)/fish/functions ~/.config/fish/functions
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.config/ghostty/config ] || ln -s $(PWD)/ghostty.config ~/.config/ghostty/config

	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf


	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc 
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions/
	rm -f ~/.gitconfig
	rm -f ~/.agignore
	rm -f ~/.config/ghostty/config
	rm -f ~/.tmux

.PHONY: all clean sync 
