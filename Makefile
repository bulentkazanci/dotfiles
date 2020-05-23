install:
	@./setup.sh

copy:
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc



.PHONY: all start install
