#!/bin/bash

########################################################################
# File Name    : text_tools.sh
# Description  : A bash script to edit HTML files with functions for
#                text indentation removal, addition, word wrapping,
#                HTML header beautification, and special indentation
#                for lists and tables.
# Dependencies : sed, fmt, fold
# Usage        : • Make the script executable with
#                chmod +x text_tools.sh
#                • Run the script with:
#                bash text_tools.sh <file>
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

# Function to remove indentation
remove_indent() {
    local file="$1"
    read -p "Enter the indentation symbols (default is ' \\t'): " symbols
    symbols=${symbols:-" \t"}
    read -p "Remove all indentation or N levels? (all/n): " mode
    if [[ "$mode" == "n" ]]; then
        read -p "Enter the number of levels to remove: " levels
    fi
    read -p "Remove indentation for all lines? (y/n): " multiline

    if [[ "$mode" == "all" ]]; then
        if [[ "$multiline" == "y" ]]; then
            sed -i "s/^[${symbols}]*//g" "$file"
        else
            sed -i "1s/^[${symbols}]*//" "$file"
        fi
    elif [[ "$mode" == "n" ]]; then
        for ((i = 0; i < levels; i++)); do
            if [[ "$multiline" == "y" ]]; then
                sed -i "s/^[${symbols}]//g" "$file"
            else
                sed -i "1s/^[${symbols}]//" "$file"
            fi
        done
    fi
}

# Function to add indentation
add_indent() {
    local file="$1"
    read -p "Enter the indentation character (default is ' '): " indent_char
    indent_char=${indent_char:-" "}
    read -p "Enter the number of indents: " num_indents
    read -p "Add indent to empty lines? (y/n): " indent_empty
    read -p "Add indent to all lines? (y/n): " multiline

    local indent=""
    for ((i = 0; i < num_indents; i++)); do
        indent+="$indent_char"
    done

    if [[ "$multiline" == "y" ]]; then
        if [[ "$indent_empty" == "y" ]]; then
            sed -i "s/^/${indent}/" "$file"
        else
            sed -i "/\S/s/^/${indent}/" "$file"
        fi
    else
        if [[ "$indent_empty" == "y" ]]; then
            sed -i "1s/^/${indent}/" "$file"
        else
            sed -i "1/\S/s/^/${indent}/" "$file"
        fi
    fi
}

# Function to wrap words
wrap_text() {
    local file="$1"
    read -p "Enter the maximum line width: " width
    read -p "Break words? (y/n): " break_words
    read -p "Allow leading spaces? (y/n): " allow_leading_spaces

    if [[ "$break_words" == "y" ]]; then
        fold -w "$width" -s "$file" | sed "s/ \+$//g" > temp.txt
    else
        fold -w "$width" "$file" | sed "s/ \+$//g" > temp.txt
    fi

    if [[ "$allow_leading_spaces" == "n" ]]; then
        sed -i "s/^ //" temp.txt
    fi

    mv temp.txt "$file"
}

# Function to beautify HTML header tags
beautify_html() {
    local file="$1"
    read -p "End <script> with newline? (y/n): " end_script_newline
    read -p "End <style> with newline? (y/n): " end_style_newline
    read -p "Keep array indentation? (y/n): " array_indent
    read -p "Break lines on chained methods? (y/n): " break_methods
    read -p "Space before conditional (if(x) or if (x))? (y/n): " space_before_conditional
    read -p "Unescape printable chars encoded as \\xNN or \\uNNNN? (y/n): " unescape_chars

    # Add your logic to beautify HTML as per the options provided
    # This is a placeholder; actual implementation may vary based on requirements
    # You might need an external tool like `js-beautify` to fully implement this

    # Placeholder implementation for demo purposes
    echo "Beautifying HTML headers in $file with the given options..."
}

# Main script execution
if [[ -z "$1" ]]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"

echo "Choose an option:"
echo "1. Remove Indentation"
echo "2. Add Indentation"
echo "3. Wrap Text"
echo "4. Beautify HTML"

read -p "Enter your choice: " choice

case "$choice" in
    1) remove_indent "$file" ;;
    2) add_indent "$file" ;;
    3) wrap_text "$file" ;;
    4) beautify_html "$file" ;;
    *) echo "Invalid choice." ;;
esac
