#!/bin/sh

set -e

cd ~/Dropbox/Pictures

# organize Unprocessed photos by date into Organized
find -E Unprocessed \
  -type f \
  -iregex '.*\.(jpg|jpeg|mov|heic|mp4)' \
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

# organize Unprocessed gifs/pngs by date into Organized/${lowercase-extension}
find -E Unprocessed \
  -type f \
  -iregex '.*\.(gif|png)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%Y%m%d_%H%M%S' \
        '-filename<Organized/%le/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/%le/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/%le/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/%le/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/%le/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/%le/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/%le/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/%le/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/%le/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/%le/${DateTimeOriginal}_000%-c.%le' \
        {}

# remove Organized files that have duplicate content
fdupes --recurse --reverse --sameline --omitfirst --delete --noprompt Organized

# remove photos app edit metadata
find -E Unprocessed \
  -type f \
  -regex '.*\.(aae|DS_Store)' \
  -delete

# remove empty directories
find Unprocessed -type d -empty -mindepth 1 -delete
