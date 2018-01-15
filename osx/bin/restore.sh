#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} YYYY-MM-DD"
    exit 1
fi

export BACKUP_NAME="${1}"

COMMANDS=$(cat <<COMMANDS
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/*.sparsebundle ~/Disks/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/Messages/ ~/Library/Messages/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.ssh/ ~/.ssh/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/Application\ Support/ ~/Library/Application\ Support/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.aws/ ~/.aws/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.gnupg/ ~/.gnupg/
rsync -aP /Volumes/lightster-homedir/${BACKUP_NAME}/history/.*history* ~/
COMMANDS
)

echo "$COMMANDS" | xargs -I {} -P 3 sh -c {}

echo "done"
