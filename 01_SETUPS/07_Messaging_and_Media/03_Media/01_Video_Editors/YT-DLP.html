<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>YT-DLP</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       line-height: 1.6;
       margin: 5em;
       max-width: 800px; /* Limit screen maximum width */
       margin-left: auto;
       margin-right: auto;
  }
   h1, h2, h3, h4, h5, h6 {
       font-weight: bold;
       margin-bottom: 0.5em;
  }
   h1 {
       font-size: 2.5em;
       line-height: 1.2;
  }
   h2 {
       font-size: 2em;
       line-height: 1.3;
  }
   h3 {
       font-size: 1.8em;
       line-height: 1.4;
  }
   p {
       margin: 1em 0;
       text-align: justify; /* Justify text for better readability */
  }
   a {
       color: #007bff;
       text-decoration: none;
  }
   a:hover {
       text-decoration: underline;
  }
   blockquote {
       margin: 1em 0;
       padding: 0 1em;
       border-left: 3px solid #ccc;
  }
   blockquote cite {
       font-style: italic;
  }
   img {
       max-width: 100%;
       height: auto;
       display: block;
       margin: 1em 0;
  }
   pre {
       background-color: #f8f9fa;
       border: 1px solid #ccc;
       padding: 1em;
       overflow: auto;
       white-space: pre-wrap; /* Wrap long lines in preformatted text */
  }
   code {
       font-family: Consolas, Monaco, 'Andale Mono', monospace;
       font-size: 0.9em;
  }
  /* Tables */
   table {
       width: 100%;
       border-collapse: collapse;
       margin-bottom: 1em;
  }
   th, td {
       border: 1px solid #ccc;
       padding: 0.8em;
  }
   th {
       background-color: #f2f2f2;
  }
  /* Lists */
   ul, ol {
       margin: 1em 0;
       padding-left: 2em;
  }
  /* Miscellaneous */
   sup {
       vertical-align: super;
       font-size: smaller;
  }
   sub {
       vertical-align: sub;
       font-size: smaller;
  }
   @media screen and (max-width: 600px) {
      /* Adjustments for smaller screens */
       body {
           font-size: 16px; /* Font size for better readability */
           line-height: 1.5;
           margin: 0.5em;
      }
       h1 {
           font-size: 2em;
      }
       h2 {
           font-size: 1.8em;
      }
       h3 {
           font-size: 1.6em;
      }
       th, td {
           padding: 0.6em;
      }
       pre {
           padding: 0.5em;
      }
  }
</style>
</head>
<body>

  <h2>YT-DLP</h2>
  
  <p>YT-DLP is a feature-rich command-line YouTube audio/video downloader.</p>
  
  <a href="https://github.com/yt-dlp/yt-dlp" target="_blank">https://github.com/yt-dlp/yt-dlp</a><br>
  <a href="https://github.com/oleksis/youtube-dl-gui" target="_blank">https://github.com/oleksis/youtube-dl-gui</a><br>
  
  <pre><code><span>$ </span>sudo apt install yt-dlp</code></pre>
  
  <h5>If the New Version Is Not Available Through apt</h5>
  
  <p>Use Debian Backports (Recommended for Stability)</p>
  
  <pre><code>
  echo "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
  sudo apt update
  sudo apt install -t $(lsb_release -cs)-backports yt-dlp
  </code></pre>
  
  <p>Manually Install the Latest Version. This method ensures that you're running the latest version without impacting other system packages.</p>
  
  <pre><code>
  sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
  </code></pre>
  
  <p>Add a Backports Repository. Avoid using PPAs on Debian unless you're sure the packages are compatible.</p>
  
  <pre><code>
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update
  sudo apt install yt-dlp
  </code></pre>
  
  <h5>Basic Commands</h5>
  
  <pre><code>
  • Download a video or playlist:
  $ yt-dlp [URL]
  
  • List available formats:
  $ yt-dlp -F [URL]
  
  • Download a specific format by format code:
  $ yt-dlp -f 247 [URL]
  
  • Download the best video with a maximum resolution of 480p:
  $ yt-dlp -f "best[height<=480]" [URL]
  
  • Download the worst video quality available:
  $ yt-dlp -f worstvideo [URL]
  
  • Specify the output filename:
  $ yt-dlp -o 'filename' [URL]
  
  • Download with a maximum resolution and metadata:
  $ yt-dlp -f "best[height<=480]" -o '%(title)s by %(uploader)s on %(upload_date)s in %(playlist)s.%(ext)s' [URL]
  $ yt-dlp --force-generic-extractor -f "best[height<=480]" -o '%(title)s by %(uploader)s on %(upload_date)s in %(playlist)s.%(ext)s' [URL]
  $ yt-dlp -f best -o '%(title)s by %(uploader)s on %(upload_date)s in %(playlist)s.%(ext)s' [URL]
  
  • Download with a maximum resolution and metadata using proxies:
  $ yt-dlp -f "best[height<=480]" -o '%(title)s by %(uploader)s on %(upload_date)s in %(playlist)s.%(ext)s' https://invidio.us/watch?v=r8f-3syiFSc
  $ yt-dlp --proxy "http://yourproxyserver:port" -f "best[height<=480]" -o '%(title)s by %(uploader)s on %(upload_date)s in %(playlist)s.%(ext)s' [URL]
  
  • Download other metadata:
  $ yt-dlp --write-description --write-info-json --write-annotations --write-sub --write-thumbnail [URL]
  
  • Download audio-only:
  $ yt-dlp -x --audio-format mp3 [URL]
  </code></pre>
  
  <h5>Subtitles Commands</h5>
  
  <pre><code>
  • Download video with embedded subtitles (hardcoded):
  $ yt-dlp --write-subs --embed-subs --sub-lang en [URL]
  
  • Download video and merge subtitles into the video file:
  $ yt-dlp --write-subs --embed-subs --merge-output-format mp4 [URL]
  
  • Download video with subtitles in multiple languages:
  $ yt-dlp --write-subs --embed-subs --sub-lang en,es [URL]
  
  • Download video with auto-generated subtitles:
  $ yt-dlp --write-auto-subs --embed-subs --sub-lang en [URL]
  
  • Download best video and audio with embedded subtitles:
  $ yt-dlp -f bestvideo+bestaudio --write-subs --embed-subs [URL]
  
  • Download with custom output template and embedded subtitles:
  $ yt-dlp -o '~/Downloads/%(title)s.%(ext)s' --write-subs --embed-subs [URL]
  
  • Download video with subtitles burned into the video (requires ffmpeg):
  $ yt-dlp -f bestvideo+bestaudio --sub-lang en --convert-subs srt --embed-subs --merge-output-format mp4 --recode-video mp4 [URL]
  
  • Download subtitles in a specific language and convert to SRT:
  $ yt-dlp --write-subs --sub-lang en --convert-subs srt [URL]
  
  • Download subtitles without video:
  $ yt-dlp --skip-download --write-subs --sub-lang en [URL]
  
  • Download and select specific subtitle format (e.g., SRT):
  $ yt-dlp --write-subs --sub-lang en --sub-format srt [URL]
  </code></pre>
  
  <h5>Advanced Commands</h5>
  
  <pre><code>
  • Download video with custom output template:
  $ yt-dlp -o '~/Downloads/%(title)s.%(ext)s' [URL]
  
  • Limit download speed (e.g., to 500K):
  $ yt-dlp --limit-rate 500K [URL]
  
  • Download best video and audio separately and merge:
  $ yt-dlp -f bestvideo+bestaudio [URL]
  
  • Download from a playlist starting from a specific video:
  $ yt-dlp --playlist-start 3 [URL]
  
  • Update yt-dlp to the latest version:
  $ sudo yt-dlp -U
  </code></pre>
  
</body>
</html>