#!/bin/bash

echo "Welcome to music-dl. Enter in a youtube playlist URL:"
read playlisturl

echo "Enter in the name of the playlist (typically Music ##):"
read albumname

mkdir -p downloads
cd downloads

if [ -d "dltmp" ]
then 
    rm -rf dltmp
fi 

mkdir dltmp && cd dltmp

youtube-dl --format "bestaudio[ext=m4a]"\
    -o "$albumname/%(playlist_index)s - %(title)s.%(ext)s"\
    --add-metadata\
    --postprocessor-args "-metadata artist=Youtube -metadata album=\"$albumname\""\
    --embed-thumbnail $playlisturl

mv ./* .. # move out of dltmp
cd .. # exit dltmp
rmdir dltmp # remove dltmp (now empty)
cd "$albumname" # open new album

# Import into Apple's magical music ecosystem and sync with phone.
open -a Music.app *