mkfile_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current_dir = $(patsubst %/,%,$(dir $(mkfile_path)))

all: git-pull configs app-store pretty done

git-pull:
	git pull

configs:
	mkdir -p ~/.tmp ~/.gnupg
	ln -sfn $(current_dir)/git/config ~/.gitconfig
	ln -sfn $(current_dir)/bash/bash_profile ~/.bash_profile
	ln -sfn $(current_dir)/bash/bashrc ~/.bashrc
	ln -sfn $(current_dir)/osx/psqlrc ~/.psqlrc
	ln -sfn $(current_dir)/vim/vimrc ~/.vimrc
	ln -sfn $(current_dir)/vim/ctags ~/.ctags
	ln -sfn $(current_dir)/osx/eslintrc ~/.eslintrc
	ln -sfn $(current_dir)/osx/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	ln -sfn $(current_dir)/tmux.conf ~/.tmux.conf
	ln -sfn $(current_dir)/zshrc ~/.zshrc

pretty:
	bash $(current_dir)/osx/bin/init-mac-more.sh

done:
	bash $(current_dir)/osx/bin/make-done.sh

atom:
	/Applications/Atom.app/Contents/Resources/app/apm/bin/apm install --packages-file ~/.dotfiles/apm.txt

atom-freeze:
	/Applications/Atom.app/Contents/Resources/app/apm/bin/apm list --installed --bare >~/.dotfiles/apm.txt
