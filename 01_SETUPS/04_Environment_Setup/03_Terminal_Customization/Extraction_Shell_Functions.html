<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Extract Incorporated in Shell</title>
  </head>  
  
  <h2>All-in-one Extract Incorporated in Shell (Shell Function)</h2>
 
  <p>To set up the extract function, start by installing the required tools.</p>

  <p>Simplified installation list:</p> 
  <pre><code>$ sudo apt install -y unzip tar unrar</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install -y unzip tar unrar')">Copy</button>
     
  <p>Advanced installation list:</p> 
  <pre><code>$ sudo apt install -y tar gzip 7zip unrar zlib1g bzip2 xz-utils tarlz</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install -y tar gzip 7zip unrar zlib1g bzip2 xz-utils tarlz')">Copy</button>

  <h4>Incorporating the Script into Your Shell Configuration</h4>
  
  <h4>Simplified Extract Function into Your Shell Configuration</h4>

  <ol>
  <li>
    <p>Open your <code>.bashrc</code> or <code>.bash_profile</code> file
     using a text editor. For example, you can use <code>nano</code>:</p>
    <pre><code>$ sudo apt install -y unzip tar unrar</code></pre>
    <button onclick="navigator.clipboard.writeText('sudo apt install -y unzip tar unrar')">Copy</button>
    <pre><code>$ nano ~/.bashrc</code></pre>
    <button onclick="navigator.clipboard.writeText('nano ~/.bashrc')">Copy</button>
  </li>

  <li>
    <p><strong>Add the <code>extract()</code> function</strong> to the file:</p>
  <pre><code>
  # Extract common archive files by file extension
  extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz|*.tgz) tar xzf "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tar.bz2|*.tbz2) tar xjf "$1" ;;
            *.zip) unzip "$1" ;;
            *.rar) unrar x "$1" ;;
            *)
                echo "Unsupported file format: '$1'"
                ;;
        esac
    else
        echo "'$1' is not a valid archive file."
    fi
  }
  </code></pre>
  </li>

  <li>
    <p><strong>Save and exit the text editor</strong>. In Nano, you can do this by pressing
     <code>Ctrl + O</code> to write the changes and <code>Ctrl + X</code> to exit.</p>
  </li>

  <li>
    <p><strong>Source your updated configuration file</strong> to apply the changes immediately:</p>
    <pre><code>$ source ~/.bashrc</code></pre>
    <button onclick="navigator.clipboard.writeText('source ~/.bashrc')">Copy</button>
    <p>or</p>
    <pre><code>$ source ~/.bash_profile</code></pre>
    <button onclick="navigator.clipboard.writeText('source ~/.bash_profile')">Copy</button>
  </li>
  </ol>

  <h4>Usage</h4>

  <p>You can now use the <code>extract</code> function directly from your terminal to extract
   archive files. For example:</p>

  <pre><code>$ extract example.tar.gz</code></pre>
  <button onclick="navigator.clipboard.writeText('extract example.tar.gz')">Copy</button>
 
  <h4>Advanced Extract Function into Your Shell Configuration</h4> 
  
  <ol>
  <li>
    <p>Open your <code>.bashrc</code> or <code>.bash_profile</code> file
     using a text editor. For example, you can use <code>nano</code>:</p>
    <pre><code>$ sudo apt install -y tar gzip 7zip unrar zlib1g bzip2 xz-utils tarlz</code></pre>
    <button onclick="navigator.clipboard.writeText('sudo apt install -y tar gzip 7zip unrar zlib1g bzip2 xz-utils tarlz')">Copy</button>
    <pre><code>$ nano ~/.bashrc</code></pre>
    <button onclick="navigator.clipboard.writeText('nano ~/.bashrc')">Copy</button>
  </li>

  <li>
    <p><strong>Add the <code>extract()</code> function</strong>
     along with the <code>is_encrypted()</code> helper function
     to the file. You can copy the following entire script:</p>
  <pre><code>
  # Function to check if a file is encrypted
  is_encrypted() {
    file "$1" | grep -q "encrypted"
  }

  # Function to securely prompt for password
  prompt_password() {
    local password=""
    local prompt="Enter password for $1: "
    
   # Prompt for password without echoing to the terminal
   while IFS= read -rs -p "$prompt" char; do
        # Exit loop when Enter key is pressed
        if [[ -z $char ]]; then break; fi
        password+="$char"
        prompt='*'
    done
    echo "$password"
  }

  # Extract common archive files by file extension
  extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.gz|*.tgz) tar xzf "$1" ;;
            *.tar|*.tar.xz) tar xf "$1" ;;
            *.tar.bz2|*.tbz2) tar xjf "$1" ;;
            *.xz) unxz "$1" ;;
            *.zip)
                if is_encrypted "$1"; then
                    password=$(prompt_password "$1")
                    unzip -P "$password" "$1"
                else
                    unzip "$1"
                fi
                ;;
            *.Z) uncompress "$1" ;;
            *.tar.zst) tar -I=unzstd -xf "$1" ;;
            *.zst) unzstd "$1" ;;
            *.7z)
                if is_encrypted "$1"; then
                    password=$(prompt_password "$1")
                    7z x -p"$password" "$1"
                else
                    7z x "$1"
                fi
                ;;
            *.tar.gz.gpg|*.tgz.gpg)
                gpg -d "$1" | tar xzf -
                ;;
            *.tar.gpg)
                gpg -d "$1" | tar xf -
                ;;
            *.tar.bz2.gpg|*.tbz2.gpg)
                gpg -d "$1" | tar xjf -
                ;;
            *.zip.gpg)
                password=$(prompt_password "$1")
                gpg -d "$1" | unzip -P "$password" -
                ;;
            *.xz.gpg)
                gpg -d "$1" | unxz -
                ;;
            *)
                echo "Unsupported file format: '$1'"
                ;;
        esac
    else
        echo "'$1' is not a valid archive file."
    fi
  }
  </code></pre>
  </li>
  <li>
    <p><strong>Save and exit the text editor</strong>.
    In Nano, you can do this by pressing <code>Ctrl + O</code>
    to write the changes and <code>Ctrl + X</code> to exit.</p>
  </li>
  <li>
    <p><strong>Source your updated configuration file</strong> to apply the changes immediately:</p>
    <pre><code>$ source ~/.bashrc</code></pre>
    <button onclick="navigator.clipboard.writeText('source ~/.bashrc')">Copy</button>
    <p>or</p>
    <pre><code>$ source ~/.bash_profile</code></pre>
    <button onclick="navigator.clipboard.writeText('source ~/.bash_profile')">Copy</button>
  </li>
  </ol>

  <h4>Usage</h4>

  <p>You can now use the <code>extract</code> function directly from your terminal to extract archive
   files. For example:</p>

  <pre><code>$ extract example.tar.gz</code></pre>
  <button onclick="navigator.clipboard.writeText('extract example.tar.gz')">Copy</button>
  

</body>
</html>