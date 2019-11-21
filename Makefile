install:
	brew bundle
	@./setup.sh


copy:
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc


.PHONY: all start install