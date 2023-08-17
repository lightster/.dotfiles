# .dotfiles

The dotfiles I use on my machines

## Setup

### Install .dotfiles
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lightster/.dotfiles/HEAD/osx/bin/install.sh)"
```

### Install minimal dependencies
```bash
cd ~/.dotfiles
./osx/bin/init-minimal.sh <COMPUTER_NAME>
```

### <a href="onepassword://">Setup 1password</a>

### <a href="https://appstore.com">Login to the Mac App Store</a>

### Bootstrap the Mac
```bash
./osx/bin/init-mac.sh <BUNDLE_NAME>
```

### Sign in to apps

- Dropbox
- Google Chrome

### Setup Terminal

- GPG
  ```bash
  gpg --import --allow-secret-key-import /path/to/private-key.asc
  ```

- Setup SSH key

- Finish CLI setup
  ```bash
  make pretty
  make done
  make atom
  ```

### System Preferences

#### Desktop & Dock
- Check *Automatically hide and show the dock*
- Uncheck *Show recent applications in Dock*

#### Displays

Arrangement:
- Arrange displays as appropriate
- Move menubar to main screen

Night Shift:
- Schedule: Sunset to Sunrise
- Color Temperature: 75% (closer to more warm)

#### Wallpaper
- Choose a dark background so the menu bar is dark

#### Screensaver
- Monterey

#### Lock Screen
- Start Screen Saver when inactive for: 5 minutes
- Require password *1 minute* after sleep or screen saver begins

#### Touch ID & Password
- Check *Use your Apple Watch to unlock apps and your Mac*

Battery:
- Check *Show Percentage*

#### Privacy & Security
- Turn On FileVault

#### Keyboard
- Key Repeat: fastest
- Delay Until Repeat: second shortest
- Keyboard Shortcuts:
  - Services:
    - Text
      - Uncheck *Open man Page in Terminal*
      - Uncheck *Search man Page Index in Terminal*
    - Spotlight:
      - Uncheck: *Show Spotlight search*
  - Modifier Keys:
    - Internal Keyboard:
      - Caps Lock: Escape
    - USB Keyboard:
      - Caps Lock: Escape
      - Option: Command
      - Command: Option

#### Mouse

- Tracking speed: third fastest
- Scrolling speed: third fastest

### Alfred
- Setup Powerpack License

Advanced:
- Setup Sync folder to "~/Dropbox/Application Support/Alfred"

Appearance:
- Set theme to *Alfred Modern Dark*

General:
- Set hotkey to Cmd+Space

### Amphetamine
General:
- Quick-Start a Session: Left click
- Check *Launch Amphetamine at Login*

Sessions:
- Default Duration: 2 hours

Notifications:
- Session end sound: Spoon and cup

Appearance:
- Menu Bar Image: Tea Kettle
- Menu Bar Text:
  - Check *Show session time remaining in menu bar*
  - Small font size

### Magnet

- Setup Layout Keyboard Shortcuts:
  - Left: Cmd + Opt + Left
  - Right: Cmd + Opt + Right
  - Center: Cmd + Opt + Down
  - Full Screen: Cmd + Opt + Up
- Launch at Login

### Sublime Text

- Setup License

### Finder

General:
- Uncheck all under *Show these items on the desktop*
- New Finder windows show: lightster

Sidebar settings:
- Favorites
  - [ ] Recents
  - [ ] AirDrop
  - [x] Applications
  - [x] Desktop
  - [x] Documents
  - [x] Downloads
  - [ ] Movies
  - [ ] Music
  - [ ] Pictures
  - [x] lightster
- iCloud
  - [ ] iCloud Drive
- Locations
  - [x] [Computer]
  - [ ] Hard Disks
  - [x] External disks
  - [x] CDs, DVDs, and iOS Devices
  - [x] Cloud Storage
  - [x] Bonjour computers
  - [x] Connected servers
- Tags
  - [ ] Recent Tags

## Preparing a clean Mac

Generally I recommend disabling internet connectivity so the Messages database is not updated during the snapshot or restore.

### On the old Mac / before wipe

```bash
bash osx/bin/snapshot.sh
```

### On the new Mac / after wipe

```bash
bash os/bin/restore.sh YYYY-MM-DD
```

## Acknowledgements

Parts of my .dotfiles repo is inspired, borrowed, or completely ripped from:

 - https://github.com/zacharyrankin/dotfiles
 - https://github.com/mathiasbynens/dotfiles
