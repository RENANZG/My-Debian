#!/usr/bin/env bash

########################################################################
# File Name    : pdf_margins_remover.sh
# Description  : Remove in batch margins of PDF files.
# Dependencies :
# Usage        : • Make the script executable with
#                chmod +x
#                • Run the script with [no] arguments:
#                bash
# Author       :
# License      :
########################################################################

# Convert PDF to PNG images
pdftoppm -png input.pdf page

# Crop the images to remove the watermark
for i in page-*.png; do
    mogrify "$i" -crop 3704x1852+0+20 +repage cropped-"$i"
done

# Convert cropped images back to a single PDF
mogrify cropped-page-*.png cropped-output.pdf

# Clean up intermediate files
# rm page-*.png cropped-page-*.png
