#!/usr/bin/env bash

########################################################################
# File Name   : video_convert_ffmpeg.sh
# Description : This script converts video files in a specified source
#               folder to MP4 format with a specified resolution using
#               ffmpeg and saves them in a specified destination folder. #               This script doesn't include other parameters like for
#               the encoder, quality, frame rate or audio bitrate.
# Usage       : • Make the script executable with
#                 chmod +x video_convert_ffmpeg.sh
#               • Run the script with arguments:
#                 bash video_convert_ffmpeg.sh <source_folder>
#                 <destination_folder> <resolution>
#               • Resolution examples:
#                  - 240p (SD): 426x240     - 360p (SD): 640x360
#                  - 480p (SD): 854x480     - 720p (HD): 1280x720
#                  - 1080p (HD): 1920x1080  - 1440p (2k): 2560x1440
#                  - 2160p (4K): 3840x2160  - 4320p (8k): 7680x4320
# Parameters  : • Removing Metadata
#               ffmpeg -i input.mp4 -map_metadata -1 -c copy output.mp4
#               • Changing Frame Rate
#               ffmpeg -i input.mp4 -r 15 output.mp4
#               • Changing Frame Size (Resolution)
#               ffmpeg -i input.mp4 -vf scale=426:240 output.mp4
#               • Changing Aspect Ratio
#               ffmpeg -i in.mp4 -vf "scale=426:240,setdar=4/3" out.mp4
#               • Changing Streams (Adding/Removing Audio or Video)
#               ffmpeg -i input.mp4 -map 0:v -c copy output.mp4  #Keeps #               only the video stream
#               ffmpeg -i input.mp4 -i new_audio.mp3 -map 0:v -map 1:a -
#               c:v copy -c:a aac output.mp4 #To add a new audio stream
#               • All-in-one
#               ffmpeg -i input.mp4 -map_metadata -1 -r 15 -
#               vf "scale=426:240,setdar=4/3" -map 0:v -c:v libx264 -
#               map 0:a -c:a aac output.mp4
# Notes       : FFmpeg contains three specifc command tools:
#                 1. ffprobe: A multimedia tool that provides metadata
#               about digital multimedia including, but not limited to,
#               duration, frame rate, frame size, aspect ratio, codec,
#               streams (video, audio, and data), etc.
#                 2. ffplay: A media player that utilizes the FFmpeg
#               framework to display multimedia files. While not all
#               encompassing, it will play proprietary and open-source
#               media files.
#                 3. ffmpeg: A command line tool to convert multimedia
#               file formats as well as various properties within the
#               file, such as codecs, container, frame rate, aspect
#               ratio, and still images.
# Author      : Me and the bois
# License     : Free of charge, no warranty
# References  : https://github.com/FFmpeg/FFmpeg (License: LGPL or GPL)
#               https://www.cvedetails.com/vendor/3611/Ffmpeg.html
########################################################################

# Check if at least three arguments are provided
if [ $# -lt 3 ]; then
    echo "Usage: $0 <source_folder> <destination_folder> <resolution>"
    read -p "Press enter to continue"
    exit 1
fi

SOURCE_FOLDER="$1"
DESTINATION_FOLDER="$2"
RESOLUTION="$3"
DESTINATION_EXT="mp4"
OUTPUT_FOLDER="converted_videos"

# Validate resolution format (e.g., 426x240)
if ! [[ "$RESOLUTION" =~ ^[0-9]+x[0-9]+$ ]]; then
    echo "Error: Resolution must be in the format WIDTHxHEIGHT (e.g., 426x240)."
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed or not found in PATH."
    exit 1
fi

# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Source folder '$SOURCE_FOLDER' not found."
    exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$DESTINATION_FOLDER/$OUTPUT_FOLDER"

# Iterate over each MP4 file in the source folder
for FILE in "$SOURCE_FOLDER"/*.mp4; do
    if [ -f "$FILE" ]; then
        FILENAME=$(basename -- "$FILE")
        FILENAME_NOEXT="${FILENAME%.*}"
        OUTPUT_FILE="$DESTINATION_FOLDER/$OUTPUT_FOLDER/Output_${FILENAME_NOEXT}.${DESTINATION_EXT}"

        # Convert video using ffmpeg with specified resolution
        ffmpeg -i "$FILE" -vf "scale=$RESOLUTION" "$OUTPUT_FILE"
        if [ $? -eq 0 ]; then
            echo "Successfully converted: $FILENAME"
        else
            echo "Error converting: $FILENAME"
        fi
    fi
done

echo "Conversion completed."
