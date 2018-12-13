#!/bin/sh

set -e

cd ~/Dropbox/Pictures

# organize Unprocessed photos by date into Organized
find -E Unprocessed \
  -type f \
  -iregex '.*\.(jpg|mov|heic|mp4)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%m/%Y%m%d_%H%M%S' \
        '-filename<Organized/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/${DateTimeOriginal}_000%-c.%le' \
        {}

# remove Organized photos that have duplicate content
fdupes --recurse --reverse --sameline --omitfirst --delete --noprompt Organized
