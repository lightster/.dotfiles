#!/bin/bash

export BACKUP_NAME=$(date "+%Y-%m-%d")
export BACKUP_VOLUME=Pollywog
mkdir -p /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/history

COMMANDS=$(cat <<COMMANDS
rsync -a --partial ~/Disks/*.sparsebundle /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/
rsync -a --partial ~/.dotfiles/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.dotfiles/
rsync -a --partial ~/backup/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/backup/
rsync -a --partial ~/github/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/github/
rsync -a --partial ~/.github.bk/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/github.bk/
rsync -a --partial ~/go/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/go/
rsync -a --partial ~/Library/Messages/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/Messages/
rsync -a --partial ~/.ssh/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.ssh/
rsync -a --partial ~/.tmux/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/tmux/
rsync -a --partial '"'${HOME}/Library/Application Support/'"' '"'/Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/Application Support/'"'
pg_dump -U postgres -F c dev_sqlboss >/Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/sqlboss.pgc
rsync -a --partial ~/.aws/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.aws/
rsync -a --partial ~/.gnupg/ /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.gnupg/
rsync -a --partial ~/.*history* /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/history
COMMANDS
)

echo "$COMMANDS" | xargs -I {} -P 3 sh -c {}

echo "done"
