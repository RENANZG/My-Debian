<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cheat Sheet</title>
<style>
        body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        margin: 20px;
        }
        table {
        width: 100%;
        border-collapse: collapse;
        }
        th, td {
        border: 1px solid #000;
        padding: 8px;
        text-align: left;
        }
        th {
        background-color: #f2f2f2;
        }
        pre, code {
        background-color: #f4f4f4;
        padding: 10px;
        border-radius: 5px;
        display: block;
        margin: 2px 0;
        overflow-x: auto;
        }
        pre < code {
        background-color: #f4f4f4;
        padding: 10px;
        border-radius: 5px;
        display: block;
        margin: 2px 0;
        overflow-x: auto;
        }        
        button {
        margin-top: 5px;
        padding: 5px 5px;
        font-size: 1em;
        cursor: pointer;
        }
</style>
</head>
<body>

<h1>Cheat Sheet</h1>

<h2>Create a key pair</h2>
<pre><code>
gpg --full-gen-key
...
Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 
Requested keysize is 2048 bits
Please specify how long the key should be valid.
         0 = key does not expire
      &lt;n&gt;  = key expires in n days
      &lt;n&gt;w = key expires in n weeks
      &lt;n&gt;m = key expires in n months
      &lt;n&gt;y = key expires in n years
Key is valid for? (0) 1y
...
GnuPG needs to construct a user ID to identify your key.

Real name: &lt;name&gt;
Email address: &lt;email&gt;
Comment: &lt;comment&gt;
...
</code></pre>

<h2>List keys</h2>
<pre><code>
gpg -k
gpg --keyid-format long --list-keys
gpg --keyid-format long --list-keys &lt;email&gt;
</code></pre>

<h2>Export key</h2>
<pre><code>
gpg --output pubkey.gpg --armor --export &lt;email&gt;
</code></pre>

<h2>Delete keys from keyring</h2>
<pre><code>
gpg --delete-secret-and-public-key &lt;keyid&gt;
</code></pre>

<h2>Upload keys to keyservers</h2>
<pre><code>
gpg --send-keys &lt;keyid&gt;
</code></pre>

<h2>Download keys from keyservers</h2>
<pre><code>
gpg --recv-keys &lt;keyid&gt;
</code></pre>

<h2>Search keys on keyservers</h2>
<pre><code>
gpg --search-keys &lt;name or email&gt;
</code></pre>

<h2>Import key</h2>
<pre><code>
gpg --import key.asc
</code></pre>

<h2>Print key fingerprint</h2>
<pre><code>
gpg fingerprint &lt;keyid&gt;
</code></pre>

<h2>Sign key</h2>
<pre><code>
gpg --sign-key &lt;keyid&gt;
</code></pre>

<h2>List signatures</h2>
<pre><code>
gpg --list-sigs &lt;keyid&gt;
</code></pre>

<h2>Export keys and trustdb for backup purposes</h2>
<pre><code>
$ gpg -a --export &lt;keyid&gt; &gt; public-gpg.key
$ gpg -a --export-secret-keys &lt;keyid&gt; &gt; secret-gpg.key
$ gpg --export-ownertrust &gt; ownertrust-gpg.txt
</code></pre>

<h2>Change expiration date of a key</h2>
<pre><code>
gpg --edit-key &lt;keyid&gt;
gpg&gt; expire
Changing expiration time for the primary key.
Please specify how long the key should be valid.
         0 = key does not expire
      &lt;n&gt;  = key expires in n days
      &lt;n&gt;w = key expires in n weeks
      &lt;n&gt;m = key expires in n months
      &lt;n&gt;y = key expires in n years
Key is valid for? (0) 1y
...
gpg&gt; save
gpg --send-keys &lt;keyid&gt;
</code></pre>

<h2>Symmetric encryption</h2>
<pre><code>
gpg --symmetric --cipher-algo AES256 file.txt # encrypt
gpg -d file.txt.gpg # decrypt
</code></pre>

<h2>Force agent to forget passwords</h2>
<pre><code>
gpgconf --reload gpg-agent
</code></pre>

<h2>Change ttl of cached keys</h2>
<p>Add the following to $HOME/.gnupg/gpg-agent.conf:</p>
<pre><code>
default-cache-ttl 1800
max-cache-ttl 1800
</code></pre>
<p>Then reload the agent:</p>
<pre><code>
gpgconf --kill gpg-agent
</code></pre>

</body>
</html>
