<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Browsers Security</title>
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
  
  <h2>Browsers</h2>
  <br>
  
  <ul>
   <li>
     <p><a href="https://avoidthehack.com/util/browser-comparison">Browser Comparison</a></p>
  </li>
  </ul>
  
  <h4>Recent Browser Security Vulnerabilities</h4>
  
  <table border="1">
  <thead>
    <tr>
      <th>CVE Code</th>
      <th>Description</th>
      <th>Browser Affected</th>
      <th>CVE Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="https://www.mozilla.org/en-US/security/advisories/mfsa2024-16/">CVE-2024-29944</a></td>
      <td>Privileged JavaScript Execution via Event Handlers</td>
      <td>Mozilla Firefox</td>
      <td>8.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/12/zero-day-alert-apple-rolls-out-ios.html">CVE-2023-7024</a></td>
      <td>Use-after-free vulnerability in Blink rendering engine of Google Chrome</td>
      <td>Google Chrome</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/12/zero-day-alert-apple-rolls-out-ios.html">CVE-2023-42917</a></td>
      <td>Remote code execution in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/12/zero-day-alert-apple-rolls-out-ios.html">CVE-2023-42916</a></td>
      <td>Remote code execution in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/update-chrome-now-google-releases-patch.html">CVE-2023-5217</a></td>
      <td>Memory corruption in V8 JavaScript engine of Google Chrome</td>
      <td>Google Chrome</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/apple-rushes-to-patch-3-new-zero-day.html">CVE-2023-41993</a></td>
      <td>Memory corruption in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/apple-rushes-to-patch-3-new-zero-day.html">CVE-2023-41992</a></td>
      <td>Memory corruption in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/apple-rushes-to-patch-3-new-zero-day.html">CVE-2023-41991</a></td>
      <td>Memory corruption in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/apple-rushes-to-patch-zero-day-flaws.html">CVE-2023-41064</a></td>
      <td>Arbitrary code execution in Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/09/apple-rushes-to-patch-zero-day-flaws.html">CVE-2023-41061</a></td>
      <td>Arbitrary code execution in Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/06/zero-day-alert-google-issues-patch-for.html">CVE-2023-3079</a></td>
      <td>Memory corruption in Skia graphics library of Google Chrome</td>
      <td>Google Chrome</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/05/webkit-under-attack-apple-issues.html">CVE-2023-32409</a></td>
      <td>Heap buffer overflow in WebKit on Apple iOS (Safari)</td>
      <td>Apple iOS (Safari)</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/04/google-chrome-hit-by-second-zero-day.html">CVE-2023-2136</a></td>
      <td>Use-after-free vulnerability in DOM handling of Google Chrome</td>
      <td>Google Chrome</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://thehackernews.com/2023/04/google-releases-urgent-chrome-update-to.html">CVE-2023-2033</a></td>
      <td>Integer overflow in rendering engine of Google Chrome</td>
      <td>Google Chrome</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td><a href="https://www.mozilla.org/en-US/security/advisories/mfsa2023-28/">CVE-2023-29539</a></td>
      <td>Out-of-bound memory access in WebGL on macOS</td>
      <td>Mozilla Firefox</td>
      <td>7.5</td>
    </tr>
    <tr>
      <td><a href="https://www.mozilla.org/en-US/security/advisories/mfsa2023-15/">CVE-2023-29546</a></td>
      <td>Buffer overflow in JavaScript JIT compiler</td>
      <td>Mozilla Firefox</td>
      <td>7.5</td>
    </tr>
  </tbody>
  </table>

  <h4>• LibreWolf</h4>
  <p> <a href="https://librewolf.net/installation/debian/">LibreWolf Installation on Debian</a> </p>
  
  <h4>• Firefox</h4>
  <p> <a href="https://cvedetails.com/vulnerability-list/vendor_id-452/product_id-22101/Mozilla-Firefox-Esr.html">Firefox ESR Vulnerabilities</a> </p>
  <p> <a href="https://cvedetails.com/vendor/452/Mozilla.html">Mozilla Vulnerabilities</a> </p> <pre><code><span>$ </span>sudo apt install firefox-esr</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install firefox-esr')"> Copy </button>
  
  <h4>• Chromium</h4>
  <p> <a href="https://cvedetails.com/vulnerability-list/vendor_id-1224/product_id-15031/Google-Chrome.html">Chromium Vulnerabilities</a> </p> <pre><code><span>$ </span>sudo apt install chromium</code></pre>
  <button onclick="navigator.clipboard.writeText('sudo apt install chromium')"> Copy </button>
  
</body>
</html>
