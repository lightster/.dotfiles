#!/bin/sh

set -e

cd ~/Dropbox/Pictures

# organize Unprocessed photos by date into Organized
find -E Unprocessed \
  -type f \
  -iregex '.*\.(jpg|jpeg|mov|heic|mp4|m4v|avi)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%m/%Y%m%d_%H%M%S' \
        '-filename<Organized/Unknown/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/Unknown/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/Unknown/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/Unknown/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/Unknown/${DateTimeOriginal}_000%-c.%le' \
        '-filename<Organized/Unknown/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Unknown/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Unknown/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Unknown/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Unknown/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${Model;}/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/${Model;}/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/${Model;}/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/${Model;}/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/${Model;}/${DateTimeOriginal}_000%-c.%le' \
        '-filename<Organized/${Model;}/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${Model;}/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${Model;}/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${Model;}/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/${Model;}/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
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
  -iregex '.*\.(aae|DS_Store)' \
  -delete

# remove empty directories
find Unprocessed -type d -empty -mindepth 1 -delete
