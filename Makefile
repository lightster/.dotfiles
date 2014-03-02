mkfile_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current_dir = $(patsubst %/,%,$(dir $(mkfile_path)))

all: templates

templates:
	php bin/build-templates.php

install:
	ln -sfn $(current_dir)/git/config ~/.gitconfig
	ln -sfn $(current_dir)/osx/bash_profile ~/.bash_profile
	ln -sfn $(current_dir)/osx/bashrc ~/.bashrc

