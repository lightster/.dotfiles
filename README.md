.dotfiles
=========

The *nix dot files I use on my machines

## Initial Setup

```bash
curl -sS https://raw.githubusercontent.com/lightster/.dotfiles/master/osx/bin/init-mac.sh >/tmp/init.mac.sh
bash /tmp/init.mac.sh computer-name git-email git-template
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

## Finish Terminal Setup

```bash
cd ~/.dotfiles

make pretty
make ssh-key
make done
```

## Alfred

1. Setup Powerpack License
2. Setup Sync folder to "~/Dropbox/Application Support/Alfred"

## System Preferences

Spotlight:
 - Disable "Show Spotlight search" keyboard shortcut

## App Store

Install:
 - Amphetamine
 - Be Focused Pro
 - Dash 2
 - Slack
 - Window Tidy

## Other Applications

Install:
 - [Postgres.app](http://postgresapp.com)

## Amphetamine

 - Default Session Duration: 2 hours
 - Menu Bar Action: "Left: Start Session"
 - Launch Amphetamine at Login
 - Do Not Show Amphetamine in Dock
 - Disable all notifications except for automatic session end
 - Icon: Coffee Cup

## Window Tidy

 - Setup Security/Privacy System Preference
 - Setup Layouts:
    - Left Half (Cmd + Opt + Left)
    - Right Half (Cmd + Opt + Right)
    - Center (Cmd + Opt + Down)
    - Full Screen (Cmd + Opt + Up)

## PHP Storm

 - Import settings from:
   `/Users/lightster/Dropbox/Application\ Support/phpstorm-lightster.jar`

## Postgres.app

 - Uncheck Show Welcome Window
 - Check Start Postgres.app Automatically
 - Data Directory: /Volumes/data/postgres/var-9.5

## Sublime Text

 - Setup License

## Terminal

Update Preferences:
 - Keyboard
    - Uncheck "Scroll alternate screen"

## Battery Icon

 - Show Percentage

# Acknowledgements

Parts of my .dotfiles repo is inspired, borrowed, or completely ripped from:

 - https://github.com/zacharyrankin/dotfiles
 - https://github.com/mathiasbynens/dotfiles
