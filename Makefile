# Makefile to do stuff with configurations

DOTBACKUP = $(HOME)/.backup_dotfiles
DOTFILES = bash_personal bash_utils git_utils gitconfig git-completion bashmarks

dotfiles: backup_directory
	for filename in $(DOTFILES); do \
	mv $(HOME)/.$${filename} $(DOTBACKUP)/$${filename}; \
	cp dotfiles/$${filename} $(HOME)/.$${filename}; \
	done ;

backup_directory:
	- mkdir -p $(DOTBACKUP)