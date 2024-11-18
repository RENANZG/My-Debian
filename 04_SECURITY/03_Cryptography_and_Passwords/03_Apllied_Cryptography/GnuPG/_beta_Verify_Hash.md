<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify Debian Linux ISO File Hash</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      margin: 20px;
    }
    
    pre,
    code {
      background-color: #f4f4f4;
      padding: 10px;
      border-radius: 5px;
      display: block;
      margin: 10px 0;
    }
    
    button {
      margin-top: 10px;
      padding: 5px 10px;
      font-size: 1em;
      cursor: pointer;
    }
    
    details {
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <h1>Download Debian Linux ISO and Verify Hash</h1>
  <section>
    <h2>Debian DVD ISO</h2>
    <p>Open your Terminal (CTRL+ALT+T) and download the latest Debian DVD ISO:</p>
    <pre><code>
curl -s https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/ |
grep -oE 'debian-[0-9]+\.[0-9]+\.[0-9]+-amd64-DVD-[0-9]+\.iso' |
xargs -I {} wget -nv --show-progress "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/{}"
    </code></pre><button onclick="navigator.clipboard.writeText('curl -s https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/ | grep -oE 'debian-[0-9]+\\.[0-9]+\\.[0-9]+-amd64-DVD-[0-9]+\\.iso' | xargs -I {} wget -nv --show-progress &quot;https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/{}&quot;')">Copy</button>
    <p>Download the DVD checksums:</p>
    <ul>
      <li>
        <a href="https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/SHA256SUMS" target="_blank">SHA256SUMS</a>
      </li>
      <li>
        <a href="https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/SHA256SUMS.sign" target="_blank">SHA256SUMS.sign</a>
      </li>
    </ul>
    <p>Verify the integrity of the ISO file:</p>
    <pre><code>
ls -l ~/Downloads
    </code></pre>
    <p>Verify with <a href="https://www.debian.org/CD/verify" target="_blank">Debian Verify Page</a></p>
    <p>If necessary, install Coreutils:</p>
    <pre><code>
$ sudo apt install coreutils
    </code></pre><button onclick="navigator.clipboard.writeText('sudo apt install coreutils')">Copy</button>
    <p>Change directory to the download location:</p>
    <pre><code>
$ cd ~/Downloads
    </code></pre><button onclick="navigator.clipboard.writeText('cd ~/Downloads')">Copy</button>
    <p>Calculate the SHA-256 hash:</p>
    <pre><code>
$ sha256sum debian-12.5.0-amd64-DVD-1.iso
    </code></pre><button onclick="navigator.clipboard.writeText('sha256sum debian-12.5.0-amd64-DVD-1.iso')">Copy</button>
    <p>Expected output:</p>
    <pre>sdd31231c0421be56f39c7a31245c423fgcc3b048ds321a3e83d2c4d714fa9a76 *debian-12.5.0-amd64-DVD-1.iso</pre>
    <p>Compare with hash in SHA256SUMS file.</p>
  </section>
  <section>
    <h2>Debian Live ISO</h2>
    <p>Choose your preferred Debian Live ISO:</p>
    <ul>
      <li><strong>XFCE:</strong></li>
      <pre><code>
curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |
grep -oE 'debian-live-[0-9]+\.[0-9]+\.[0-9]+-amd64-xfce\.iso' |
xargs -I {} wget -nv --show-progress "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}"
      </code></pre><button onclick="navigator.clipboard.writeText('curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ | grep -oE 'debian-live-[0-9]+\\.[0-9]+\\.[0-9]+-amd64-xfce\\.iso' | xargs -I {} wget -nv --show-progress &quot;https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}&quot;')">Copy</button>
      <li><strong>GNOME:</strong></li>
      <pre><code>
curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |
grep -oE 'debian-live-[0-9]+\.[0-9]+\.[0-9]+-amd64-gnome\.iso' |
xargs -I {} wget -nv --show-progress "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}"
      </code></pre><button onclick="navigator.clipboard.writeText('curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ | grep -oE 'debian-live-[0-9]+\\.[0-9]+\\.[0-9]+-amd64-gnome\\.iso' | xargs -I {} wget -nv --show-progress &quot;https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}&quot;')">Copy</button>
      <li><strong>LXQT:</strong></li>
      <pre><code>
curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |
grep -oE 'debian-live-[0-9]+\.[0-9]+\.[0-9]+-amd64-lxqt\.iso' |
xargs -I {} wget -nv --show-progress "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}"
      </code></pre><button onclick="navigator.clipboard.writeText('curl -s https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ | grep -oE 'debian-live-[0-9]+\\.[0-9]+\\.[0-9]+-amd64-lxqt\\.iso' | xargs -I {} wget -nv --show-progress &quot;https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{}&quot;')">Copy</button>
    </ul>
    <p>Download the checksums:</p>
    <ul>
      <li>
        <a href="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/SHA256SUMS" target="_blank">SHA256SUMS</a>
      </li>
      <li>
        <a href="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/SHA256SUMS.sign" target="_blank">SHA256SUMS.sign</a>
      </li>
    </ul>
  </section>
  <section>
    <h2>Manual Method with SHA-256</h2>
    <pre><code>
ls -l ~/Downloads
    </code></pre>
    <p>Verify the integrity of the ISO file:</p>
    <pre><code>
ls -l ~/Downloads
-rw-rw-r-- 1 user user 12345 Feb 01 01:01 debian-12.5.0-amd64-DVD-1.iso
-rw-rw-r-- 1 user user 12345 Feb 01 01:01 SHA512SUMS
-rw-rw-r-- 1 user user 12345 Feb 01 01:01 SHA512SUMS.sign
    </code></pre>
    <p>Verify with <a href="https://www.debian.org/CD/verify" target="_blank">Debian Verify Page</a></p>
    <p>Install Coreutils:</p>
    <pre><code>
$ sudo apt install coreutils
</code></pre><button onclick="navigator.clipboard.writeText('sudo apt install coreutils')">Copy</button>
    <p>Change directory to the download location:</p>
    <pre><code>
$ cd download_directory
</code></pre><button onclick="navigator.clipboard.writeText('cd download_directory')">Copy</button>
    <p>Calculate the SHA-256 hash:</p>
    <pre><code>
$ sha256sum debian-12.5.0-amd64-DVD-1.iso
</code></pre><button onclick="navigator.clipboard.writeText('sha256sum debian-12.5.0-amd64-DVD-1.iso')">Copy</button>
    <p>Expected output:</p>
    <pre>sdd31231c0421be56f39c7a31245c423fgcc3b048ds321a3e83d2c4d714fa9a76 *debian-12.5.0-amd64-DVD-1.iso</pre>
    <p>Compare with hash in SHA256SUMS file.</p>
  </section>
  <section>
    <h2>Semi-automatic Method with SHA-256</h2>
    <p>Download <code>SHA256SUMS</code> and <code>SHA256SUMS.sign</code> to the same directory as the ISO. Then run:</p>
    <pre><code>
$ cd download_directory
  </code></pre><button onclick="navigator.clipboard.writeText('cd download_directory')">Copy</button>
    <pre><code>
$ sha256sum -c SHA256SUMS 2&gt;&amp;1 | grep OK
  </code></pre><button onclick="navigator.clipboard.writeText('sha256sum -c SHA256SUMS 2&gt;&amp;1 | grep OK')">Copy</button>
    <p>Output should show <code>name.iso: OK</code> if hash matches.</p>
  </section>
  <section>
    <h2>Verify with MD5</h2>
    <p>Ensure <code>MD5SUMS</code> is in the same directory as ISO. Run:</p>
    <pre><code>
$ md5sum -c MD5SUMS 2&gt; /dev/null | grep OK
  </code></pre><button onclick="navigator.clipboard.writeText('md5sum -c MD5SUMS 2&gt; /dev/null | grep OK')">Copy</button>
    <p>Output should indicate <code>OK</code> if hash matches.</p>
  </section>
  <section>
    <h2>Verify Signature with GPG</h2>
    <p>Download public key:</p>
    <pre><code>
$ gpg --keyserver keyring.debian.org --recv-key YOUR_KEY_ID
  </code></pre><button onclick="navigator.clipboard.writeText('gpg --keyserver keyring.debian.org --recv-key YOUR_KEY_ID')">Copy</button>
    <p>Verify signature:</p>
    <pre><code>
$ gpg --verify SHA256SUMS.sign SHA256SUMS
  </code></pre><button onclick="navigator.clipboard.writeText('gpg --verify SHA256SUMS.sign SHA256SUMS')">Copy</button>
    <p>Output should confirm signature and key trust.</p>
  </section>
</body>
</html>
