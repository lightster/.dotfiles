.dotfiles
=========

The dot files I use on my machines

## Initial Setup

```bash
curl -sS https://raw.githubusercontent.com/lightster/.dotfiles/master/osx/bin/init-mac.sh >/tmp/init.mac.sh
bash /tmp/init.mac.sh computer-name
```

## Dropbox

1. Sign into Dropbox
2. Setup Selective Sync, deselecting:
    - Camera Uploads
    - Carousel
    - Pictures
    - Unprocessed Photos

## Google Chrome

Sign into Google accounts

## Setup GPG

- `gpg --import --allow-secret-key-import /path/to/private-key.asc`
- Import private key into GPG keychain

## Finish Terminal Setup

```bash
cd ~/.dotfiles

make pretty
make app-store
make ssh-key
make done
```

## System Preferences

Spotlight:
 - Disable "Show Spotlight search" keyboard shortcut

Screensaver:
 - Set to Aerial
 - Setup screen saver to download the videos
 - Start after: 5 minutes

Night Shift:

 - Schedule: Sunset to Sunrise
 - Color Temperature: 75% (closer to more warm)

## Alfred

1. Setup Powerpack License
2. Setup Sync folder to "~/Dropbox/Application Support/Alfred"
3. Set theme to Alfred Dark
4. Set hotkey to Cmd+Space

## Other Applications

Install:
 - [Postgres.app](http://postgresapp.com)

## Amphetamine

 - Default Session Duration: 2 hours
 - Menu Bar Action: "Left: Start Session"
 - Launch Amphetamine at Login
 - Do Not Show Amphetamine in Dock
 - Disable all notifications except for automatic session end
 - Icon: Coffee Mug

## iA Writer

 - General
   - Colors: Night mode
 - Files
   - Default extension: md
 - Library
   - Locations:
     - iCloud
     - playbook
     - Year 31
     - acloud.guru notes
 - Editor:
   - Check grammar with spelling: Uncheck
   - Indent text using: Spaces

## Window Tidy

 - Setup Security/Privacy System Preference
 - Setup Layouts:
    - Left Half (Cmd + Opt + Left)
    - Right Half (Cmd + Opt + Right)
    - Center (Cmd + Opt + Down)
    - Full Screen (Cmd + Opt + Up)
  - Launch at Login

## PHP Storm

 - Import settings from:
   `/Users/lightster/Dropbox/Application\ Support/phpstorm-lightster.jar`

## Postgres.app

 - Remove default server
 - Add server
   - Name: 9.6
   - Version: 9.6
   - Disks: /Users/lightster/Disks/Postgres/var-9.6
   - Port: 5432
   - Server settings: Automatically start server
   - Initialize

## Sublime Text

 - Setup License

## Battery Icon

 - Show Percentage

## Finder

Open Finder Preferences (Cmd+,).

General settings:

- Uncheck "External disks" under "Show these items on the desktop"
- New Finder windows show: lightster

Sidebar settings:

- Favorites
    - x All My Files
    - x AirDrop
    - √ Applications:
    - √ Downloads
    - x Movies
    - x Music
    - x Pictures
    - √ lightster
- iCloud
    - x iCloud Drive
    - √ Desktop
    - x Documents
- Shared
    - √ Back to My Mac
    - √ Connected servers
    - √ Bonjour computers
- Devices
    - √ [Computer]
    - x Hard Disks
    - √ External disks
    - √ CDs, DVDs and iPods
    - (Drag off Remote Disc)
- Tags
    - x Recent Tags

Navigate to Dropbox folder and open "Show View Options" (Cmd+J)

- √ Always Open in List View
- √ Browse in List View
- Arrange by Name
- Sort by Name
- Icon Size: Larger

Click "Use as Defaults"

# What to do when transitioning to a new Mac

On the old Mac:

```bash
BACKUP_NAME=$(date "+%Y-%m-%d")
mkdir -p /Volumes/lightster-homedir/${BACKUP_NAME}/
rsync -aP ~/Disks/*.sparsebundle /Volumes/lightster-homedir/${BACKUP_NAME}/
rsync -aP ~/Library/Messages/ /Volumes/lightster-homedir/${BACKUP_NAME}/Messages/
rsync -aP ~/.ssh/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.ssh/
rsync -aP ~/Library/Application\ Support/ /Volumes/lightster-homedir/${BACKUP_NAME}/Application\ Support/
pg_dump -U postgres -F c dev_sqlboss >/Volumes/lightster-homedir/${BACKUP_NAME}/sqlboss.pgc

rsync -aP ~/.aws/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.aws/
rsync -aP ~/.gnupg/ /Volumes/lightster-homedir/${BACKUP_NAME}/hidden.gnupg/
mkdir /Volumes/lightster-homedir/${BACKUP_NAME}/history
rsync -aP ~/.*history* /Volumes/lightster-homedir/${BACKUP_NAME}/history
```

# Acknowledgements

Parts of my .dotfiles repo is inspired, borrowed, or completely ripped from:

 - https://github.com/zacharyrankin/dotfiles
 - https://github.com/mathiasbynens/dotfiles
