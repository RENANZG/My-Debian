#!/usr/bin/env bash

########################################################################
# File Name    : file_extractor.sh
# Description  : Script to extract files, encrypted or not, in batch.
# Dependencies : tar gzip 7zip unrar zlib1g bzip2 xz-utils tarlz
# Usage        : • Make the script executable with:
#                  chmod +x file_extractor.sh
#                • Run the script with no arguments: 
#                  bash file_extractor.sh file1.rar file2.zip file3.tar
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to check if a file is encrypted
function is_encrypted() {
    file "$1" | grep -q "encrypted"
}

# Function to securely prompt for password
# Avoid echoing the password for security reasons
function prompt_password() {
    local password=""
    echo -n "Enter password for $1: "
    read -s password
    echo
}

# Extract common archive files by file extension
function extract() {
    for archive_file in "$@"; do
        if [ -f "$archive_file" ] ; then
            case "$archive_file" in
                *.tar.gz|*.tgz)             tar xzf "$archive_file" ;;
                *.tar|*.tar.xz)             tar xf "$archive_file" ;;
                *.tar.bz2|*.tbz2)           tar xjf "$archive_file" ;;
                *.xz)                       unxz "$archive_file" ;;
                *.zip)
                    if is_encrypted "$archive_file"; then
                        password=$(prompt_password "$archive_file")
                        unzip -P "$password" "$archive_file"
                    else
                        unzip "$archive_file"
                    fi ;;
                *.Z)                        uncompress "$archive_file" ;;
                *.tar.zst)                  tar -I=unzstd -xf "$archive_file" ;;
                *.zst)                      unzstd "$archive_file" ;;
                *.7z)
                    if is_encrypted "$archive_file"; then
                        password=$(prompt_password "$archive_file")
                        7z x -p"$password" "$archive_file"
                    else
                        7z x "$archive_file"
                    fi ;;
                *.tar.gz.gpg|*.tgz.gpg)     gpg -d "$archive_file" | tar xzf - ;;
                *.tar.gpg)                  gpg -d "$archive_file" | tar xf - ;;
                *.tar.bz2.gpg|*.tbz2.gpg)   gpg -d "$archive_file" | tar xjf - ;;
                *.zip.gpg)
                    password=$(prompt_password "$archive_file")
                    gpg -d "$archive_file" | unzip -P "$password" - ;;
                *.xz.gpg)                   gpg -d "$archive_file" | unxz - ;;
                *)                          echo "Unsupported file format: '$archive_file'" ;;
            esac
        else
            echo "'$archive_file' is not a valid archive file."
        fi
    done
}

# Check if at least one argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <archive_file1> [<archive_file2> ...]"
    exit 1
fi

# Call the extract function with the provided arguments
extract "$@"
