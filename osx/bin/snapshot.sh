#!/bin/bash

export BACKUP_NAME=$(date "+%Y-%m-%d")
mkdir -p /Volumes/lightster-homedir/${BACKUP_NAME}/history

COMMANDS=$(cat <<COMMANDS
rsync -aP ~/Disks/*.sparsebundle /Volumes/lightster-homedir/${BACKUP_NAME}/
rsync -aP ~/Library/Messages/ /Volumes/lightster-homedir/${BACKUP_NAME}/Messages/
rsync -aP ~/.ssh/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.ssh/
rsync -aP ~/Library/Application\ Support/ /Volumes/lightster-homedir/${BACKUP_NAME}/Application\ Support/
pg_dump -U postgres -F c dev_sqlboss >/Volumes/lightster-homedir/${BACKUP_NAME}/sqlboss.pgc
rsync -aP ~/.aws/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.aws/
rsync -aP ~/.gnupg/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.gnupg/
rsync -aP ~/.*history* /Volumes/lightster-homedir/${BACKUP_NAME}/history
COMMANDS
)

echo "$COMMANDS" | xargs -I {} -P 3 sh -c {}

echo "done"
