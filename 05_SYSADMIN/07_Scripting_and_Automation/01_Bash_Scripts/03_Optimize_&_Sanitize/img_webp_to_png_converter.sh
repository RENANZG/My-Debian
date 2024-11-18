#!/usr/bin/env bash

########################################################################
# File Name    : img_webp_to_png_converter.sh
# Description  : Convert webp images recursively in a folder to png
#                using mogrify. Take care it overwrites the original
#                file, comment to avoid removing the original file.
# Dependencies : imagemagick
# Usage        : • Make the script executable with
#                chmod +x img_webp_to_png_converter.sh
#                • Run the script with:
#                bash img_webp_to_png_converter.sh img.webp
#                bash img_webp_to_png_converter.sh img1.webp img2.webp
#                bash img_webp_to_png_converter.sh /folder
# Author       : Me and the bois
# License      : Free of charge
########################################################################

# Function to convert a single WebP image to PNG
convert_image() {
    local img="$1"
    if [ "${img: -5}" == ".webp" ]; then
        echo "Converting $img ..."
        mogrify -format png "$img"
        rm "$img"   # Comment to avoid removing
                    # the original .webp file
                    # after item conversion
    fi
}

# Function to convert WebP images recursively in a folder
convert_images_in_folder() {
    for item in "$1"/*; do
        if [ -d "$item" ]; then
            convert_images_in_folder "$item"
        elif [ -f "$item" ]; then
            convert_image "$item"
            rm "$item"   # Comment to avoid removing
                         # the original .webp file
                         # after folder conversion
        fi
    done
}

# Main script
if [ $# -eq 0 ]; then
    # No arguments provided, assume current directory
    convert_images_in_folder "."
else
    # Process each argument
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            convert_images_in_folder "$arg"
        elif [ -f "$arg" ]; then
            convert_image "$arg"
        else
            echo "Warning: $arg is not a valid file or directory"
        fi
    done
fi

echo "Conversion complete."
