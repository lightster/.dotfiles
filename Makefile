mkfile_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current_dir = $(patsubst %/,%,$(dir $(mkfile_path)))

all: git-pull configs app-store pretty done

git-pull:
	git pull

configs:
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
	mkdir -p ~/.tmp

app-store:
	bash $(current_dir)/osx/bin/make-app-store.sh

pretty:
	bash $(current_dir)/osx/bin/init-mac-more.sh

ssh-key:
	bash $(current_dir)/osx/bin/make-ssh-key.sh

done:
	bash $(current_dir)/osx/bin/setup-sudoers.sh
	bash $(current_dir)/osx/bin/make-done.sh
