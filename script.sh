#!/bin/bash

echo "Welcome to music-dl. Enter in a youtube playlist URL:"
read playlisturl

# split playlisturl by '=' and save the second half as playlistid
playlistid=$(echo $playlisturl | cut -d '=' -f 2)

# print out the playlistid
echo "Playlist ID: $playlistid"

mkdir -p downloads
cd downloads

# if playlistid is not a directory, we need to "fake run" the script to get the playlist name
if [ ! -d "$playlistid" ]; then
    echo "Playlist is fresh; dry-running youtube-dl for 3 seconds to get playlist name..."
    timeout 3s youtube-dl --format "bestaudio[ext=m4a]"\
        -o "%(playlist_id)s/%(playlist_title)s/%(title)s.%(ext)s"\
        --add-metadata\
        --postprocessor-args "-metadata album=%(playlist_title)s"\
        --embed-thumbnail\
        $playlisturl > /dev/null
    echo "Done."
fi

# cd into playlistid folder
cd $playlistid

# read the playlistname 
playlistname=$(ls)

echo "Playlist name: $playlistname"

# go back to downloads folder
cd ..

# We now know the playlist title!!!!
youtube-dl --format "bestaudio[ext=m4a]"\
    -o "%(playlist_id)s/%(playlist_title)s/%(title)s.%(ext)s"\
    --add-metadata\
    --postprocessor-args "-metadata album=\"$playlistname\""\
    --embed-thumbnail\
    $playlisturl

cd $playlistid

# Import into Apple's magical music ecosystem and sync with phone.
open -a Music.app *