#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} YYYY-MM-DD"
    exit 1
fi

export BACKUP_NAME="${1}"
export BACKUP_VOLUME=Pollywog

COMMANDS=$(cat <<COMMANDS
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/*.sparsebundle ~/Disks/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.dotfiles/ ~/.dotfiles/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/backup/ ~/backup/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/github/ ~/github/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/.github.bk/ ~/github.bk/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/go/ ~/go/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/Messages/ ~/Library/Messages/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.ssh/ ~/.ssh/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/tmux/ ~/.tmux/
rsync -a --partial '"'/Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/Application\ Support/'"' '"'${HOME}/Library/Application\ Support/'"'
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.aws/ ~/.aws/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/hidden.gnupg/ ~/.gnupg/
rsync -a --partial /Volumes/${BACKUP_VOLUME}/${BACKUP_NAME}/history/.*history* ~/
COMMANDS
)

echo "$COMMANDS" | xargs -I {} -P 3 sh -c {}

echo "done"
