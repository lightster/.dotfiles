local newline=$'\n'
local ret_status='%(?:%{$fg_bold[green]%}● :%{$fg_bold[red]%}● )%{$reset_color%}'
local time='%{$fg[green]%}%D{%H:%M:%S}%{$reset_color%}'
local host='%{$fg[red]%}$SHORT_HOST%{$reset_color%}'
local current_dir='%{$fg[blue]%}$PWD%{$reet_color%}'
local git_info='$(git_prompt_info)'
local entry='%{$fg_bold[magenta]%}\$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓"

PROMPT="${newline}${time} ${host}:${current_dir} ${git_info}${newline}${ret_status}   ${entry}"
