mkfile_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current_dir = $(patsubst %/,%,$(dir $(mkfile_path)))

all: git-pull configs pretty done

git-pull:
	git pull

configs:
	cat $(current_dir)/git/template/config \
		| sed "s#{{GIT_NAME}}#`cat $(current_dir)/git/config.user.name`#g" \
		| sed "s#{{GIT_EMAIL}}#`cat $(current_dir)/git/config.user.email`#g" \
		| sed "s#{{DOT_PATH}}#`cat $(current_dir)/git/config.dot.path`#g" \
		| sed "s#{{GIT_TEMPLATE}}#`cat $(current_dir)/git/config.dot.commit_template`#g" \
		> $(current_dir)/git/config
	ln -sfn $(current_dir)/git/config ~/.gitconfig
	ln -sfn $(current_dir)/osx/bash_profile ~/.bash_profile
	ln -sfn $(current_dir)/osx/bashrc ~/.bashrc
	ln -sfn $(current_dir)/osx/hyper.js ~/.hyper.js
	ln -sfn $(current_dir)/osx/psqlrc ~/.psqlrc
	ln -sfn $(current_dir)/vim/vimrc ~/.vimrc
	ln -sfn $(current_dir)/osx/eslintrc ~/.eslintrc

pretty:
	bash $(current_dir)/osx/bin/init-mac-more.sh

ssh-key:
	bash $(current_dir)/osx/bin/make-ssh-key.sh

done:
	bash $(current_dir)/osx/bin/setup-sudoers.sh
	bash $(current_dir)/osx/bin/make-done.sh
