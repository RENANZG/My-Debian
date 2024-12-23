<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Custom Command in Thunar</title>
</head>
<body>
  
  <h1>Custom Command in Thunar (GUI)</h1>
  
  <p>Allows you to open a plain text document with either nano or vim in dom0:</p>
  
  <ol>
    <li>Open Thunar.</li>
    <li>Right-click on the text file you want to open.</li>
    <li>Select "Open With" and then choose "Other Application...".</li>
    <li>In the dialog that appears, look for the option that says "Use a custom command".</li>
    <li>Enter the following command:</li>
  </ol>
  
  <pre><code>exo-open --launch TerminalEmulator -- nano %f</code></pre>
  
  <p>Also, you could go to the "Edit" menu and select "Configure custom actions".</p>
  
  <h2>References:</h2>
  <p><a href="https://askubuntu.com/questions/891680/xubuntu-thunar-open-terminal-here-opens-konsole-in-homefolder">Ask Ubuntu: Thunar Open Terminal Here</a></p>
</body>
</html>
