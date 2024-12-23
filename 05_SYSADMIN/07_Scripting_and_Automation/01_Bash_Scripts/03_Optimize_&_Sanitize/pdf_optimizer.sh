#!/usr/bin/env bash

########################################################################
# File Name    : pdf_optimizer.sh
# Description  : This script optimizes PDF files using Ghostscript with
#                different settings based on user selected option.
# Dependencies : Ghostscript (gs)
# Usage        : • Make the script executable with
#                  chmod +x pdf_optimizer.sh
#                • Run the script with a PDF file or a folder:
#                  bash pdf_optimizer.sh <file_or_folder>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to optimize a single PDF file
optimize_pdf() {
  input_file="$1"
  output_file="$2"
  method="$3"
  case "$method" in
    "screen")
      gs -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/$method \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=72 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=72 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=72 \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "ebook")
      gs -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/$method \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=150 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=150 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=150 \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "printer")
      gs -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/$method \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=300 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=300 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=300 \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "prepress")
      gs -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/$method \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=300 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=300 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=300 \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "acrobat")
      gs -dNOPAUSE -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/ebook \
        -dEmbedAllFonts=true \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=96 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=96 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=96 \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "scanned1")
      gs -dNOPAUSE -dBATCH -dQUIET \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=96 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=96 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=96\
        -dJPEGQ=85 \
        -dSubsetFonts=true \
        -dEmbedAllFonts=true \
        -dOptimize=true \
        -dAutoFilterColorImages=true \
        -dAutoFilterGrayImages=true \
        -dDownsampleColorImages=true \
        -dDownsampleGrayImages=true \
        -dDownsampleMonoImages=true \
        -dColorConversionStrategy=/LeaveColorUnchanged \
        -dRemoveUnusedObjects=true \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "scanned2")
      gs -dNOPAUSE -dBATCH -dQUIET \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=144 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=144 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=144 \
        -dJPEGQ=85 \
        -dSubsetFonts=true \
        -dEmbedAllFonts=true \
        -dOptimize=true \
        -dAutoFilterColorImages=true \
        -dAutoFilterGrayImages=true \
        -dDownsampleColorImages=true \
        -dDownsampleGrayImages=true \
        -dDownsampleMonoImages=true \
        -dColorConversionStrategy=/LeaveColorUnchanged \
        -dRemoveUnusedObjects=true \
        -sOutputFile="$output_file" "$input_file"
      ;;
    "advanced")
      gs -dNOPAUSE -dBATCH -dQUIET \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=300 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=300 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=300 \
        -dJPEGQ=85 \
        -dSubsetFonts=true \
        -dEmbedAllFonts=true \
        -dOptimize=true \
        -dAutoFilterColorImages=false \
        -dAutoFilterGrayImages=false \
        -dDownsampleColorImages=true \
        -dDownsampleGrayImages=true \
        -dDownsampleMonoImages=true \
        -dColorConversionStrategy=/LeaveColorUnchanged \
        -sOutputFile="$output_file" "$input_file"
      ;;
    *)
      echo "Invalid method specified."
      exit 1
      ;;
  esac
}

# Prompt user for optimization method
echo "Choose PDF optimization method:"
echo "1. Screen: Lower quality and smallest size (dpi 72)"
echo "2. Ebook: Good quality and reasonable size (dpi 150)"
echo "3. Printer: High quality, larger size (dpi 300)"
echo "4. Prepress: Best quality, largest size (dpi 300)"
echo "5. Adobe PDF: Good for old Adobe documents (dpi 96)"
echo "6. Scanned PDF: Good for scanned documents (dpi 96)"
echo "7. Scanned PDF: Good for scanned documents (dpi 144)"
echo "8. Advanced: Customized in source script"
read -p "Enter the number corresponding to your choice: " choice

# Set method based on user input
case "$choice" in
  1) method="screen" ;;
  2) method="ebook" ;;
  3) method="printer" ;;
  4) method="prepress" ;;
  5) method="acrobat" ;;
  6) method="scanned1" ;;
  7) method="scanned2" ;;
  8) method="advanced" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

# Check if input is a directory
if [ -d "$1" ]; then
  # Process all PDF files in the directory
  for pdf in "$1"/*.pdf; do
    output_pdf="${pdf%.pdf}-optimized.pdf"
    echo "Optimizing $pdf with method $method..."
    optimize_pdf "$pdf" "$output_pdf" "$method"
    echo "Output: $output_pdf"
  done
# Check if input is a single file
elif [ -f "$1" ]; then
  input_pdf="$1"
  output_pdf="${input_pdf%.pdf}-optimized.pdf"
  echo "Optimizing $input_pdf with method $method..."
  optimize_pdf "$input_pdf" "$output_pdf" "$method"
  echo "Output: $output_pdf"
else
  echo "Usage: $0 <pdf-file-or-directory>"
  exit 1
fi

echo "Optimization complete."
