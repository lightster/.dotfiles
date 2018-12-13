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
2. Setup Selective Sync, selecting on Application Support for now

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
make atom
```

## System Preferences

Spotlight:
 - Disable "Show Spotlight search" keyboard shortcut

Background:
 - Set wallpaper to dynamic

Screensaver:
 - Start after: 5 minutes

Night Shift:

 - Schedule: Sunset to Sunrise
 - Color Temperature: 75% (closer to more warm)

## Alfred

1. Setup Powerpack License
2. Setup Sync folder to "~/Dropbox/Application Support/Alfred"
3. Set theme to Alfred Dark
4. Set hotkey to Cmd+Space

## Amphetamine

 - Default Session Duration: 2 hours
 - Menu Bar Action: "Primary: Start/end session"
 - Launch Amphetamine at Login
 - Hide Amphetamine in the Dock
 - Disable all notifications except for automatic session end
    - Session end sound: Spoon and cup
 - Icon: Caffeine

## Window Tidy

 - Setup Security/Privacy System Preference
 - Setup Layouts:
    - Left 7/12 (Cmd + Opt + Left)
    - Right 5/12 (Cmd + Opt + Right)
    - Center (Cmd + Opt + Down)
    - Full Screen (Cmd + Opt + Up)
  - Launch at Login

## Sublime Text

 - Setup License

## Battery Icon

 - Show Percentage

## Finder

Open Finder Preferences (Cmd+,).

General settings:

- Under "Show these items on the desktop," uncheck everything
- New Finder windows show: lightster

Sidebar settings:

- Favorites
    - x Recents
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
    - √ Documents
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
    - x Bonjour computers
    - √ Connect servers
- Tags
    - x Recent Tags

Navigate to Dropbox folder and open "Show View Options" (Cmd+J)

- √ Always Open in List View
- √ Browse in List View
- Group by Name
- Sort by Name
- Icon Size: Larger

Click "Use as Defaults"

# Preparing a clean Mac

Generally I recommend disabling internet connectivity so the Messages database
is not updated during the snapshot or restore.

## On the old Mac / before wipe

```bash
bash osx/bin/snapshot.sh
```

## On the new Mac / after wipe

```bash
bash os/bin/restore.sh YYYY-MM-DD
```

# Acknowledgements

Parts of my .dotfiles repo is inspired, borrowed, or completely ripped from:

 - https://github.com/zacharyrankin/dotfiles
 - https://github.com/mathiasbynens/dotfiles
