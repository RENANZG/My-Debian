<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Split VeraCrypt in Qubes OS</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       margin: 0;
       padding: 20px;
       line-height: 1.6;
       max-width: 21cm; /* Limit screen maximum width */
       height: 29.7cm;
       background-color: #f9f9f9;
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
       background-color: #f4f4f4;
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

  <h1>Setting up Split VeraCrypt in Qubes OS</h1>

  <p>This guide outlines the steps to configure and use a "split VeraCrypt" setup in Qubes OS, allowing different qubes to handle storage, decryption, and access to VeraCrypt volumes securely.</p>

  <h2>Introduction</h2>

  <p>The "split VeraCrypt" setup allows multiple Qubes VMs to handle different tasks related to VeraCrypt volumes, such as storage, decryption, and usage, while ensuring the compartmentalization and security of Qubes OS.</p>

  <p>By splitting these roles into different qubes, we can create a system where the qube accessing the volume never interacts with the qube storing the encrypted volume directly. This setup leverages the isolation features of Qubes OS.</p>

  <h2>Prerequisites</h2>

  <ul>
    <li>Basic knowledge of Qubes VMs and their compartmentalization</li>
    <li>VeraCrypt command-line version installed on Decryptor VM</li>
    <li>Disposable VM setup for decryption (recommended)</li>
  </ul>

  <h2>Key Qubes Actors</h2>

  <ul>
    <li><strong>Store</strong>: The qube that holds the encrypted VeraCrypt volumes.</li>
    <li><strong>Decryptor</strong>: The qube responsible for decrypting the volumes.</li>
    <li><strong>Receiver</strong>: The qube that accesses and uses the decrypted data.</li>
    <li><strong>Keys (optional)</strong>: Manages decryption keys.</li>
  </ul>

  <h2>Step-by-Step Guide</h2>

  <h3>1. Checkout (Store)</h3>

  <p>Store holds the encrypted volume file (e.g., <code>volume.vrc</code>). This step involves mounting the file as a loop device.</p>

  <pre><code>sudo losetup /dev/loop1 /home/user/Volumes/volume.vrc</code></pre>

  <p>For read-only access, add the <code>-r</code> flag:</p>

  <pre><code>sudo losetup /dev/loop1 /home/user/Volumes/volume.vrc -r</code></pre>

  <h3>2. Mount (Dom0)</h3>

  <p>Now, in dom0, attach the loop device to Decryptor:</p>

  <pre><code>qvm-block attach Decryptor Store:loop1</code></pre>

  <p>You can also do this through the Qubes devices menu.</p>

  <h3>3. Decrypt (Decryptor)</h3>

  <p>In Decryptor, run VeraCrypt to decrypt the volume:</p>

  <pre><code>veracrypt --mount -k "keyfile" --pim=0 --stdin --slot=1 /dev/xvdi --filesystem=none</code></pre>

  <p>Then, create a loop for the decrypted device:</p>

  <pre><code>losetup /dev/loop2 /dev/mapper/veracrypt1</code></pre>

  <h3>4. Attach (Dom0)</h3>

  <p>Attach the decrypted volume from Decryptor to Receiver:</p>

  <pre><code>qvm-block attach Receiver Decryptor:loop2</code></pre>

  <h3>5. Mount (Receiver)</h3>

  <p>In Receiver, mount the decrypted volume:</p>

  <pre><code>sudo mount /dev/xvdi /mnt/decrypted</code></pre>

  <h2>Detaching and Locking the Volume</h2>

  <p>To reverse the process, first unmount the volume from Receiver:</p>

  <pre><code>sudo umount /mnt/decrypted</code></pre>

  <p>Then detach the block device:</p>

  <pre><code>qvm-block detach Receiver Decryptor:loop2</code></pre>

  <p>Finally, in Decryptor, dismount the decrypted volume:</p>

  <pre><code>veracrypt --dismount --slot=1</code></pre>

</body>
</html>