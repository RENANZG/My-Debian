#!/bin/bash

# Function to convert a filename to title case
to_title_case() {
  filename="$1"
  extension="${filename##*.}"
  base="${filename%.*}"
  
  echo "$base" | awk '{
    # Define words to exclude from capitalization
    exclude="a an the and but or nor for yet so to of at by in on up off out over"
    
    # Split the input into words
    n = split($0, words, "[-_]")
    
    # Loop through each word
    for (i = 1; i <= n; i++) {
      word = words[i]
      lower_word = tolower(word)
      
      # Capitalize the first word and the first word after a colon
      if (i == 1 || (i > 1 && words[i-1] == ":")) {
        words[i] = toupper(substr(word, 1, 1)) tolower(substr(word, 2))
      } else if (index(exclude, lower_word) == 0 || length(lower_word) > 4) {
        # Capitalize words not in the exclude list or longer than four letters
        words[i] = toupper(substr(word, 1, 1)) tolower(substr(word, 2))
      } else {
        # Otherwise, keep the word in lowercase
        words[i] = lower_word
      }
    }

    # Join the words back together
    for (i = 1; i <= n; i++) {
      printf "%s%s", words[i], (i < n ? "_" : "")
    }
    printf "\n"
  }'
}

# Iterate over each input file
for file in "$@"; do
  # Skip if it's not a file
  if [ ! -f "$file" ]; then
    echo "Skipping non-file: $file"
    continue
  fi
  
  # Get the directory, filename, and extension
  dir=$(dirname "$file")
  filename=$(basename "$file")
  extension="${filename##*.}"
  base="${filename%.*}"
  
  # Convert the base name to title case
  new_base=$(to_title_case "$base")
  
  # Create the new filename
  if [ "$base" != "$new_base" ]; then
    new_filename="$new_base.$extension"
    
    # Rename the file
    mv "$file" "$dir/$new_filename"
    echo "Renamed: $file -> $dir/$new_filename"
  else
    echo "No change needed for: $file"
  fi
done

echo "Renaming completed."
