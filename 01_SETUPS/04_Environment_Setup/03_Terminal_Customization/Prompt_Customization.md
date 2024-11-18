<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Integrating Functions and Customizing the Prompt</title>
<style>
  body {
  font-family: Arial, sans-serif;
  margin: 20px;
  pre {
  background-color: #cccccc;
  padding: 1px;
  border-radius: 3px;
  overflow: auto;
  }
  code {
  background-color: #cccccc;
  padding: 1px;
  border-radius: 3px;
  }
  pre > code {
  background-color: #cccccc;
  padding: 1px;
  border-radius: 3px;
  display: block;
  overflow: auto;
  position:relative;
  white-space: pre-wrap;
  word-wrap: break-word;
  }
</style>
</head>
<body>

  <h1>Integrating Functions and Customizing the Prompt</h1>

  <p>This tutorial explains how to integrate a function and customize the
  PS1 prompt in your <code>~/.bashrc</code>.</p>

  <!-- ######################### -->
  
  <h2>Understanding the Basics</h2>

  <ul>
  <li>The <code>~/.bashrc</code> file is a script that is executed whenever
  you start a new terminal session in Bash (the default command-line
  shell in many Linux distributions, including Debian). This file
  contains various settings and commands that configure your shell
  environment.</li>
  <li>The PS1 prompt is the primary prompt string in Bash. It defines what
  you see as the command prompt in your terminal. For example, it might
  display your username, hostname, and current directory. Customizing
  the PS1 prompt allows you to personalize this information.</li>
  </ul>

  <!-- ######################### -->
  
  <h2>Configuring a Custom Prompt Functions</h2>

  <p>To edit the <code>~/.bashrc</code> file, open a terminal and execute
  the following command:</p>

  <pre><code>nano ~/.bashrc</code></pre>

  <p>This command opens the <code>~/.bashrc</code> file in the Nano text
  editor. Nano is a simple text editor that is easy to use.</p>

  <p>Scroll to the end of the <code>~/.bashrc</code> file using the arrow
  keys on your keyboard. Add, for example, the following function to
  list files with their sizes:</p>

  <pre><code>
  # Function to list files with their sizes
  list_files_with_size() {
  local dir="${1:-.}"
  find "$dir" -type f -exec du -h {} + | sort -rh
  }
  </code></pre>

  <p>This function, named <code>list_files_with_size</code>, takes a directory
  as an argument (or uses the current directory if no argument is provided)
  and lists all files in that directory along with their sizes, sorted
  by size in descending order.</p>

  <!-- ######################### -->
  
  <h2>Customizing the PS1 Prompt</h2>
  
  <p>You can add functions to your shell configuration file (.bashrc or .zshrc)
  modifying PS1. Locate the line that starts with <code>PS1=</code>. If
  this line does not exist, add it. Modify or add your custom PS1 prompt
  customization as follows:</p>

  <pre><code>
  PS1='[\u@\h \W]\$ '
  </code></pre>
  
  <p>Or:</p>
  
  <pre><code>
  PS1='\[\033[01;32m\]\t \[\033[01;34m\]\u@\h \[\033[01;33m\]\W\[\033[00m\] \$ '
  </code></pre>
  
  <p>This PS1 prompt displays your username (<code>\u</code>), hostname
  (<code>\h</code>), and the current working directory (<code>\W</code>)
  followed by a dollar sign (<code>\$</code>), which is the default
  prompt symbol for non-root users.</p>

  <p>Save and close the file. If using Nano, save the changes by pressing
  <kbd>Ctrl + O</kbd>, then press <kbd>Enter</kbd> to confirm. Exit
  Nano by pressing <kbd>Ctrl + X</kbd>.</p>

  <p>To apply the changes made to <code>~/.bashrc</code>, reload the file
  by executing the following command in your terminal:</p>

  <pre><code>source ~/.bashrc</code></pre>

  <p>This command re-executes the <code>~/.bashrc</code> script, applying
  your changes without needing to close and reopen the terminal.</p>

  <p>The custom PS1 prompt should now be visible, and the 
  <code>list_files_with_size</code>  function can be used by typing 
  <code>list_files_with_size</code>  followed by a directory path (or no
  path to use the current directory).</p>

  <!-- ######################### -->
  
  <h2>Adding Autocompletion for Custom Functions</h2>

  <h3>Bash (Bourne Again Shell)</h3>

  <p>In Bash, you can use the <code>complete</code> built-in command to
  add autocompletion for your custom functions.</p>
  
  <p>To set up your custom function and its autocompletion, add the
  following code to your <code>.bashrc</code> file. This will define
  the <code>zip_dirs</code> function and provide autocompletion for
  it:</p>

  <pre><code>nano ~/.bashrc</code></pre>
  
  <pre><code>
  # Function to create a zip archive of directories
  zip_dirs() {
      local zip_file="$1"
      shift
      local dirs="$@"
      if [ -z "$zip_file" ] || [ -z "$dirs" ]; then
          echo "Usage: zip_dirs archive.zip dir1 [dir2 ...]"
          return 1
      fi
      zip -r "$zip_file" $dirs
  }

  # Completion function for zip_dirs
  _zip_dirs_completions() {
      local cur prev
      local zip_file_dirs

      # Get the current word being completed
      cur="${COMP_WORDS[COMP_CWORD]}"
      prev="${COMP_WORDS[COMP_CWORD-1]}"

      # Provide completions based on the current argument
      if [ ${COMP_CWORD} -eq 1 ]; then
          # Suggest file names for the zip file
          # If needed, you can adjust this part
          COMPREPLY=( $(compgen -o nospace -A file -- ${cur}) )
      else
          # Suggest directory names for the directories to be zipped
          COMPREPLY=( $(compgen -d -- ${cur}) )
      fi
  }

  # Register the completion function for zip_dirs
  complete -F _zip_dirs_completions zip_dirs
  </code></pre>

  <p>After adding the code, apply the changes by sourcing your   
  <code>.bashrc</code> file:</p>

  <pre><code>
  source ~/.bashrc
  </code></pre>
  
  <!-- ######################### -->
    
  <h2>Examples of Custom Functions</h2>

  <pre><code>
  # Function to create a zip archive of directories
  zip_dirs() {
      local zip_file="$1"
      shift
      local dirs="$@"
      if [ -z "$zip_file" ] || [ -z "$dirs" ]; then
          echo "Usage: zip_dirs archive.zip dir1 [dir2 ...]"
          return 1
      fi
      zip -r "$zip_file" $dirs
  }
  </code></pre>

  <pre><code>
  # Function to extract different types of archive files
  extract() {
      local file="$1"
      if [ -f "$file" ]; then
          case "$file" in
              *.tar.bz2)  tar xvjf "$file"     ;;
              *.tar.gz)   tar xvzf "$file"     ;;
              *.bz2)      bunzip2 "$file"      ;;
              *.gz)       gunzip "$file"       ;;
              *.tar.xz)   tar xvJf "$file"     ;;
              *.xz)       unxz "$file"         ;;
              *.zip)      unzip "$file"        ;;
              *.7z)       7z x "$file"         ;;
              *.rar)      unrar x "$file"      ;;
              *)          echo "Cannot extract '$file'." ;;
          esac
      else
          echo "'$file' is not a valid file."
      fi
  }
  </code></pre>

  <pre><code>
  # Function to convert images to another format
  convert_image() {
      local input="$1"
      local output="$2"
      if [ -z "$input" ] || [ -z "$output" ]; then
          echo "Usage: convert_image input_file output_file"
          return 1
      fi
      convert "$input" "$output"
  }
  </code></pre>

  <pre><code>
  # Function to find files with a specific extension
  find_files_by_extension() {
      local extension="$1"
      local dir="${2:-.}"
      if [ -z "$extension" ]; then
          echo "Usage: find_files_by_extension extension [directory]"
          return 1
      fi
      find "$dir" -type f -name "*.$extension"
  }
  </code></pre>

  <pre><code>
  # Function to find files with a specific extension
  find_files_by_extension() {
      local extension="$1"
      local dir="${2:-.}"

      if [ -z "$extension" ]; then
          echo "Usage: find_files_by_extension extension [directory]"
          return 1
      fi

      find "$dir" -type f -name "*.$extension"
  }
  </code></pre>

  <pre><code>
  # Function to find large files
  find_large_files() {
      local size="$1"
      local dir="${2:-.}"

      if [ -z "$size" ]; then
          echo "Usage: find_large_files size [directory]"
          return 1
      fi

      find "$dir" -type f -size +"$size" -exec du -h {} + | sort -rh
  }
  </code></pre>

  <pre><code>
  # Function to compare two files
  compare_files() {
      local file1="$1"
      local file2="$2"

      if [ -z "$file1" ] || [ -z "$file2" ]; then
          echo "Usage: compare_files file1 file2"
          return 1
      fi

      diff "$file1" "$file2"
  }
  </code></pre>
  
  <pre><code>
  # Function to sync two directories using rsync
  sync_dirs() {
      local source="$1"
      local destination="$2"

      if [ -z "$source" ] || [ -z "$destination" ]; then
          echo "Usage: sync_dirs /source/dir /destination/dir"
          return 1
      fi

      rsync -av --delete "$source" "$destination"
  }
  </code></pre>

  <pre><code>
  # Function to check file integrity with MD5 checksum
  check_md5() {
      local file="$1"
      local checksum="$2"

      if [ -z "$file" ] || [ -z "$checksum" ]; then
          echo "Usage: check_md5 file checksum"
          return 1
      fi

      if [ "$(md5sum "$file" | awk '{print $1}')" = "$checksum" ]; then
          echo "Checksum is valid."
      else
          echo "Checksum is invalid."
      fi
  }
  </code></pre>
  
  <pre><code>
  # Function to display detailed network status
  network_debug() {
      echo "Checking internet connectivity..."
      if ping -c 1 google.com &> /dev/null; then
          echo "Internet is connected."
      else
          echo "Internet is not connected."
      fi

      echo -e "\nActive network connections:"
      netstat -tuln

      echo -e "\nNetwork interface information:"
      ip link show

      echo -e "\nIP address information:"
      ip addr show

      echo -e "\nRouting table:"
      ip route show

      echo -e "\nDNS resolution details:"
      cat /etc/resolv.conf

      echo -e "\nDetailed network statistics:"
      netstat -s
  }
  </code></pre>

  <pre><code>
  # Function to monitor system resource usage
  monitor_resources() {
      echo "CPU Usage:"
      top -bn1 | grep "Cpu(s)"
    
      echo "Memory Usage:"
      free -h
    
      echo "Disk Usage:"
      df -h
  }
  </code></pre>
  
  <pre><code>
  # Function to get the Git status
  parse_git_status() {
      local git_status=$(git status --short 2>/dev/null)
      if [ -n "$git_status" ]; then
          echo -e "\[\033[01;33m\][$(parse_git_branch)]\[\033[00m\]"
      fi
  }

  export PS1='\u@\h:\W$(parse_git_status)\$ '
  </code></pre>

  </body>
  </hmtl>