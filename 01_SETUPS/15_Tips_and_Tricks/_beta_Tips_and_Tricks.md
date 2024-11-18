<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tips and Tricks</title>
</head>
<body>

<h1>Tips and Tricks</h1>

<h4>Visualize folder tree</h4>

<pre><code>$ sudo apt install tree</code></pre>
<button onclick="navigator.clipboard.writeText('sudo apt install tree')">Copy</button>

<pre>
• List directories only: 
$ tree -d 
• Control the depth of the tree: 
$ tree -d -L 2
</pre>

<h4>Schedule a Shutdown in Command Line</h4>

<h5>Shutdown at specific time</h5>
<pre>$ sudo shutdown -h 23:59</pre>

<h5>Shutdown at specific date and time</h5>

<p>Since 24 hours (24×60=1440 minutes), you could adapt.</p>
<pre>$ sudo shutdown +1440</pre>
<p>Execute shutdown +60 at a specific time and day:</p>

<pre>
$ sudo apt install at 
$ sudo echo "shutdown +767" | at 08:46am 2024-09-11
</pre>

<h4>Set an Alarm from the Terminal</h4>

<p>With MPV Player</p>

<pre>$ sleep 5m && mpv /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga</pre>

<p>With pulseaudio-utils package (paplay)</p>

<pre>$ sleep 5m && mpv /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga</pre>

<h4>Use Terminal as a Stopwatch</h4>

<pre>$ time cat</pre>

<p>Press <code>CTRL + C</code> to stop.</p>

<h4>Commands for you to find large files</h4>
<pre>
$ df -h 
$ df -h /home/$USER/Downloads 
$ du -h ~/Downloads | sort -rh | head -n 10 
$ find ~/Downloads -type f -size +3G -exec du -h {} + | sort -rh 
$ find /home/$USER/Downloads -xdev -type f -size +1G 
$ find . -size +1M -printf "%p \t%k kb\n" | sort -k2n
$ find  -type f  -exec  du -Sh {} +  |  grep .pdf | sort -rh  |  head -n 50
</pre>

<h5>Find the largest packages</h5>
<pre><code>
$ dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' | 
sort -k 2 -n | grep -v deinstall | awk '{printf "%.3f MB \t %s\n", $2/(1024), $1}'
</code></pre>
<button onclick="navigator.clipboard.writeText('dpkg-query --show --showformat=\'${Package;-50}\\t${Installed-Size}\\n\' | sort -k 2 -n | grep -v deinstall | awk \'{printf \"%.3f MB \\t %s\\n\", $2/(1024), $1}\'')">Copy</button>

<h4>Editing text with sed in terminal</h4>
<p>Be cautious of using <code>-n</code> (quiet) with <code>-i</code> (in-place): the former disables automatic printing of lines and the latter changes the file in-place without a backup. Make a backup before editing <code>-i.bak</code>.</p>
<pre><code>$ sed --options [optional SCRIPT] [INPUT STREAM]</code></pre>
<button onclick="navigator.clipboard.writeText('sed --options [optional SCRIPT] [INPUT STREAM]')">Copy</button>

<pre>
• Append line after match: 
$ sed '/option/a Hello World' *.txt 
• Insert line before match: 
$ sed '/option\/i Hello World' *.txt 
• Append text after a line for the specific match only: 
$ sed '0,/option\/a Hello World' *.txt 
• Append text before a line for the specific match only: 
$ sed '0,/option\/i Hello World' *.txt 
• Inserting a text file. Content of text1 after the first line of text2.txt: 
$ sed -i -e '1r text1' text2.txt

• Append string in a multiline text: 
$ sed -i '/pattern/ r snippet.txt' filename 
• Batch inserting specific text after pattern in .txt files: 
$ sed -i '/SearchPattern/a New Text' *.txt 
$ find . -name '*.txt' -exec sed -i -e 's/textp1/textp2 text.txt/g' {} \;

• Replacement syntax: 
$ sed s/regexp/replacement/[flags] 
• Replace closed with open on lines containing code: 
$ sed '/code/ s/closed/open/' text.txt 
• Replace all closed with open on lines containing code: 
$ sed '/code/ s/closed/open/g' text.txt 
• Replace all occurrences of ‘hello’ to ‘world’ in the file input.txt: 
$ sed 's/hello/world/g' input.txt > output.txt

• Batch removing specific text in .txt files, the –i option tells to sed make the change in place, inside the file itself: 
$ sed -i 's/text//g' *.txt 
• Batch making a backup before editing the file, by specifying a suffix when using –i: 
$ sed -i.bak 's/word//g' *.txt
</pre>

<h5>Convert Lowercase to Uppercase Characters</h5>
<pre><code>$ sed -i 's/.*/\U&/' text.txt</code></pre>
<button onclick="navigator.clipboard.writeText('sed -i \'s/.*/\\U&/\' text.txt')">Copy</button>
<pre><code>$ sed 's/[a-z]/\U&/g' < ./myfile.txt</code></pre>
<pre><code>$ echo "HELLO WORLD" | sed 's/[A-Z]/\L&/g'</code></pre>
<button onclick="navigator.clipboard.writeText('echo \"HELLO WORLD\" | sed \'s/[A-Z]/\\L&/g\'')">Copy</button>

<h5>Convert Uppercase to Lowercase Characters</h5>
<pre><code>$ echo "hello world" | sed 's/[a-z]/\U&/g'</code></pre>
<button onclick="navigator.clipboard.writeText('echo \"hello world\" | sed \'s/[a-z]/\\U&/g\'')">Copy</button>

<h5>Remove leading spaces and tabs from line</h5>
<pre><code>$ sed 's/^[ \t]*//' text.txt</code></pre>
<button onclick="navigator.clipboard.writeText('sed \'s/^[ \\t]*//\' text.txt')">Copy</button>

<h5>Remove all digits in a range</h5>
<pre><code>$ sed 's/[0-9]//g' text.txt</code></pre>
<button onclick="navigator.clipboard.writeText('sed \'s/[0-9]//g\' text.txt')">Copy</button>
<pre>*Note, in terminal: Alt + u Make uppercase from the cursor position to the end of the word. Alt + l Make lowercase from the cursor position to the end of the word/text.</pre>

<h4>Reopen with maximized browser</h4>
<p>To open browser with maximized window use "--start-maximized" as a parameter.</p>
<pre>
$ nano /home/user/Desktop/browser.desktop
[Desktop Entry]
Exec=/usr/bin/browser --start-maximized %U
</pre>

<h4>Getting window sizes in shell</h4>
<pre>$ wmctrl -lG</pre>

<h4>Changing default editor for <code>visudo</code></h4>
<p>By default, Linux systems use the <code>$VISUAL</code> or <code>$EDITOR</code> environment variables (usually defined in your <code>~/.bashrc</code> file or <code>/etc/profile</code>) as the default editor the <a href="https://linux.die.net/man/8/visudo">visudo</a> command. If you'd prefer to use a different editor, such as <a href="https://nano-editor.org/">nano</a>, you can use either of these methods.</p>
<ol>
    <li>
        To temporarily use a different editor, run:
        <pre><code>$ sudo EDITOR=/path/to/editor visudo</code></pre>
        For example, to use <code>nano</code>, you would run:
        <pre><code>$ sudo EDITOR=nano visudo</code></pre>
    </li>
    <li>
        To permanently change the default editor, edit the <code>/etc/sudoers</code> file (you can use the temporary method above!) and add the following line to the file near the top, but after <code>Defaults env_reset</code>:
        <pre><code>Defaults editor=/path/to/editor</code></pre>
    </li>
</ol>
<p><a href="https://unix.stackexchange.com/questions/4408/how-to-set-visudo-to-use-a-different-editor-than-the-default-on-fedora">Reference</a></p>

<h4>Test if a bash shell built-in command or external program package</h4>
<p>References:</p>
<ul>
    <li><a href="http://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html">GNU Bash Builtins</a></li>
    <li><a href

="https://gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html">Shell Builtin Commands</a></li>
    <li><a href="http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_04">POSIX Utilities</a></li>
    <li><a href="https://en.wikipedia.org/wiki/POSIX">POSIX Wikipedia</a></li>
    <li><a href="https://packages.debian.org/stable">Debian Packages</a></li>
    <li><a href="http://www.gsp.com/cgi-bin/man.cgi?section=1&topic=zshbuiltins">zsh Builtins</a></li>
</ul>
<pre>
• Use type command:
$ type -t cd 
$ type -t ls 
$ type -t test 
$ type -t echo 
$ type -t apt 
$ type -t grep 
$ type -t for 
• Use builtin command:
$ builtin cd 
$ builtin ls 
$ builtin test 
$ builtin echo 
$ builtin apt 
$ builtin grep 
$ builtin for 
• You can use the builtin command enable to show the list of builtin commands and their activation state:
$ enable -a
</pre>
<p>Why use the built-in command? It does not depend on granting permissions to install packages, works on reduced sets like Linux embedded hardware (IoTs), reduces the attack surface, and has better performance.</p>

<h4>Changing terminal command output language</h4>
<pre>
• For just a single command, from native language to English:
$ LC_ALL=C man ls 
$ LC_ALL=C sudo apt update
</pre>

<h4>Grep - Global regular expression search</h4>
<pre>
• Commands:
$ man find | grep -A 4 -- '-size' 
$ man find | grep -e '-size'
</pre>

<h4>Using xargs to execute commands on multiple files</h4>
<pre>
• Find all text files and list their contents:
$ find . -name "*.txt" | xargs cat
• Delete all .bak files:
$ find . -name "*.bak" | xargs rm
</pre>

<h4>Compress and Decompress files</h4>
<pre>
• Compress a directory:
$ tar -czvf archive_name.tar.gz /path/to/directory
• Decompress an archive:
$ tar -xzvf archive_name.tar.gz
</pre>

<h4>Monitor system resource usage</h4>
<pre>
• Monitor CPU and memory usage:
$ top
• Detailed resource usage by processes:
$ htop
</pre>

<h4>Network troubleshooting</h4>
<pre>
• Check active network connections:
$ netstat -tuln
• Display network interface configurations:
$ ifconfig
• Ping a host to check connectivity:
$ ping google.com
</pre>

<h4>Create a symbolic link</h4>
<pre>
• Create a symlink:
$ ln -s /path/to/original /path/to/link
</pre>

<h4>Batch rename files</h4>
<pre>
• Rename all .txt files to .bak:
$ for f in *.txt; do mv -- "$f" "${f%.txt}.bak"; done
</pre>

<h4>Disk usage analysis</h4>
<pre>
• Check disk space usage of directories and subdirectories:
$ du -sh *
</pre>

<h4>Find and kill a process</h4>
<pre>
• Find a process by name:
$ pgrep process_name
• Kill a process by PID:
$ kill -9 PID
</pre>

<h4>List installed packages</h4>
<pre>
• List all installed packages:
$ dpkg -l
• List all installed packages with details:
$ apt list --installed
</pre>

<h4>Check OS version</h4>
<pre>
• Check the OS version:
$ lsb_release -a
• Check the kernel version:
$ uname -r
</pre>

</body>
</html>
