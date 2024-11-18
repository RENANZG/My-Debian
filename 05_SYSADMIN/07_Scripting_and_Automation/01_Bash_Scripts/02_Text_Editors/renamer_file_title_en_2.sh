#!/bin/bash

# Function to convert a string to snake_case with title case
to_snake_case() {
  echo "$1" | sed -E "s/-/_/g" | awk '{
    for (i = 1; i <= NF; i++) {
      if (tolower($i) ~ /^(in|on|at|of|and|or|but|to|the|a|an)$/) {
        $i = tolower($i)
      } else {
        $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
      }
    }
    print $0
  }' FS="_" OFS="_"
}

# Export the function so it can be used by 'bash -c'
export -f to_snake_case

# Find and rename the files
find . -maxdepth 1 -type f -name '*-*' -exec bash -c '
  for file; do
    filename=$(basename "$file")
    extension="${filename##*.}"
    base="${filename%.*}"
    new_name=$(to_snake_case "$base")
    mv "$file" "$(dirname "$file")/$new_name.$extension"
  done
' bash {} \;

echo "Renaming completed."
