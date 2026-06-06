mkfile_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current_dir = $(patsubst %/,%,$(dir $(mkfile_path)))

all: git-pull configs app-store pretty done

git-pull:
	git pull

configs: build-hooks claude-mcp
	mkdir -p ~/.tmp ~/.gnupg ~/.claude ~/.config/zellij
	ln -sfn $(current_dir)/git/config ~/.gitconfig
	ln -sfn $(current_dir)/bash/bash_profile ~/.bash_profile
	ln -sfn $(current_dir)/bash/bashrc ~/.bashrc
	ln -sfn $(current_dir)/osx/psqlrc ~/.psqlrc
	ln -sfn $(current_dir)/vim/vimrc ~/.vimrc
	ln -sfn $(current_dir)/vim/ctags ~/.ctags
	ln -sfn $(current_dir)/osx/eslintrc ~/.eslintrc
	ln -sfn $(current_dir)/osx/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	ln -sfn $(current_dir)/tmux.conf ~/.tmux.conf
	ln -sfn $(current_dir)/zellij/layouts ~/.config/zellij/layouts
	ln -sfn $(current_dir)/zshrc ~/.zshrc
	ln -sfn $(current_dir)/claude/settings.json ~/.claude/settings.json
	ln -sfn $(current_dir)/claude/CLAUDE.md ~/.claude/CLAUDE.md
	ln -sfn $(current_dir)/claude/rules ~/.claude/rules
	ln -sfn $(current_dir)/claude/hooks ~/.claude/hooks
	ln -sfn $(current_dir)/claude/skills ~/.claude/skills

build-hooks:
	cd $(current_dir)/claude/hooks/deny-rm-root && go build -o deny-rm-root .

claude-mcp:
	@if command -v claude >/dev/null 2>&1 && [ -x /Applications/Bear.app/Contents/MacOS/bearcli ]; then \
		claude mcp remove -s user bear >/dev/null 2>&1 || true; \
		claude mcp add -s user bear -- /Applications/Bear.app/Contents/MacOS/bearcli mcp-server; \
	else \
		echo "Skipping bear MCP setup (claude CLI or Bear.app not found)"; \
	fi

pretty:
	bash $(current_dir)/osx/bin/init-mac-more.sh

done:
	bash $(current_dir)/osx/bin/make-done.sh

atom:
	/Applications/Atom.app/Contents/Resources/app/apm/bin/apm install --packages-file ~/.dotfiles/apm.txt

atom-freeze:
	/Applications/Atom.app/Contents/Resources/app/apm/bin/apm list --installed --bare >~/.dotfiles/apm.txt
