#!/usr/bin/env bash

########################################################################
# File Name   : video_convert_handbreak.sh
# Description : This script converts video files in a specified source
#               folder to MP4 format with a specified resolution and
#               saves them in a destination folder. This script includes
#               other parameters like -e x264 for the encoder, -q 22 for
#               quality, -r 15 for frame rate, and -B 64 for audio
#               bitrate.
# Usage       : • Make the script executable with
#               chmod +x video_convert_handbreak.sh
#               • Run the script with arguments:
#               bash video_convert_handbreak.sh <source_folder>
#               <destination_folder> <resolution>
#               • Resolution examples:
#                 - 240p (SD): 426x240     - 360p (SD): 640x360
#                 - 480p (SD): 854x480     - 720p (HD): 1280x720
#                 - 1080p (HD): 1920x1080  - 1440p (2k): 2560x1440
#                 - 2160p (4K): 3840x2160  - 4320p (8k): 7680x4320
# Notes       :  It's possible to remove metadata using ExifTool
#                exiftool -all= video.mp4
# Author      : Me and the bois
# License     : Free of charge
# References  : https://github.com/HandBrake/HandBrake (License:GPL v.2)
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
HANDBRAKE_CLI="HandBrakeCLI"

# Validate resolution format (e.g., 426x240)
if ! [[ "$RESOLUTION" =~ ^[0-9]+x[0-9]+$ ]]; then
    echo "Error: Resolution must be in the format WIDTHxHEIGHT (e.g., 426x240)."
    exit 1
fi

# Check if HandBrakeCLI is installed
if ! command -v $HANDBRAKE_CLI &> /dev/null; then
    echo "Error: HandBrakeCLI is not installed or not found in PATH."
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

        # Extract width and height from resolution
        WIDTH="${RESOLUTION%x*}"
        HEIGHT="${RESOLUTION#*x}"

        # Convert video using HandBrakeCLI with specified resolution
        $HANDBRAKE_CLI -i "$FILE" -o "$OUTPUT_FILE" -e x264 -q 22 -r 15 -B 64 -w "$WIDTH" -l "$HEIGHT"
        if [ $? -eq 0 ]; then
            echo "Successfully converted: $FILENAME"
        else
            echo "Error converting: $FILENAME"
        fi
    fi
done

echo "Conversion completed."
