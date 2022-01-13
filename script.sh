#!/bin/bash

echo "Welcome to music-dl. Enter in a youtube playlist URL:"
read playlisturl

# split playlisturl by '=' and save the second half as playlistid
playlistid=$(echo $playlisturl | cut -d '=' -f 2)

# print out the playlistid
echo "Playlist ID: $playlistid"

mkdir -p downloads
cd downloads

# if playlistid is a folder in the current directory:
# 1) go into the folder
# 2) read the only folder in the current folder and save its name as playlistname
# else if playlistid is not a folder in the current directory:
# run youtube-dl but send SIGINT after 1 second
if [ ! -d "$playlistid" ]; then
    timeout 3s youtube-dl --format "bestaudio[ext=m4a]"\
        -o "%(playlist_id)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"\
        --add-metadata\
        --postprocessor-args "-metadata artist=Youtube -metadata album=%(playlist_title)s"\
        --embed-thumbnail\
        $playlisturl
fi

# cd into playlistid folder
cd $playlistid

# read the playlistname 
playlistname=$(ls)

cd ..
youtube-dl --format "bestaudio[ext=m4a]"\
    -o "%(playlist_id)s/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"\
    --add-metadata\
    --postprocessor-args "-metadata artist=Youtube -metadata album=\"$playlistname\""\
    --embed-thumbnail\
    $playlisturl

cd $playlistid

# Import into Apple's magical music ecosystem and sync with phone.
open -a Music.app *