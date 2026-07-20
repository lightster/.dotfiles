#!/bin/sh

set -e

cd ~/Dropbox/Pictures

# Organize movies thats have CreationDate set
find -E Unprocessed \
  -type f \
  -iregex '.*\.(mov)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%m/%Y%m%d_%H%M%S' \
        '-filename<Organized/Devices/Unknown/${CreationDate}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${CreationDate}_000%-c.%le' \
        {}

# organize Unprocessed photos by date into Organized
find -E Unprocessed \
  -type f \
  -iregex '.*\.(jpg|jpeg|mov|heic|mp4|m4v|avi)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%m/%Y%m%d_%H%M%S' \
        '-filename<Organized/Devices/Unknown/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/Unknown/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/Devices/Unknown/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/Devices/Unknown/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/Unknown/${DateTimeOriginal}_000%-c.%le' \
        '-filename<Organized/Devices/Unknown/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/Unknown/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/Unknown/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/Unknown/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/Unknown/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${DateTimeOriginal}_000%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/${Model;}/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        {}

# organize Unprocessed gifs/pngs by date into Organized/${lowercase-extension}
find -E Unprocessed \
  -type f \
  -iregex '.*\.(gif|png)' \
  -print0 | xargs -0 -I {} \
    exiftool \
      -P -d '%Y/%Y%m%d_%H%M%S' \
        '-filename<Organized/Devices/%le/${FileModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/%le/${GPSDateTime}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/%le/${MediaCreateDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/%le/${ModifyDate}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/%le/${DateTimeOriginal}_${SubSecTimeOriginal;}%-c.%le' \
        '-filename<Organized/Devices/%le/${FileModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/%le/${GPSDateTime}_000%-c.%le' \
        '-filename<Organized/Devices/%le/${MediaCreateDate}_000%-c.%le' \
        '-filename<Organized/Devices/%le/${ModifyDate}_000%-c.%le' \
        '-filename<Organized/Devices/%le/${DateTimeOriginal}_000%-c.%le' \
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
