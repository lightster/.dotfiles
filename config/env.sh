set -a
for file in ~/.dotfiles/config/env.d/*.sh; do
  [ -r "$file" ] && source "$file"
done
set +a
