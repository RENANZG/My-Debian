<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PowerShell Script</title>
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
  
  <h1>PowerShell Basics</h1>
  
  <p>PowerShell is a powerful task automation and configuration management
    framework from Microsoft. It includes a command-line shell, an associated
    scripting language, and a framework for managing and automating system
    tasks.</p>

  <h2>Variable Handling</h2>
  
  <p>In PowerShell, variables are denoted by the <code>$</code> symbol followed
    by the variable name. PowerShell variables are dynamic and can hold
    different types of data, including strings, integers, arrays, and objects.
    Here are some key points about variable handling:</p>

  <h3>Creating and Using Variables</h3>
  
  <p>To create a variable, simply assign a value to it:</p>
  
  <pre><code>$name = "John Doe"</code></pre>
  
  <p>To access or display the value of a variable:</p>
  
  <pre><code>Write-Output $name</code></pre>

  <h3>Type of Variables</h3>
  
  <p>PowerShell variables are typed, and you can use the <code>[type]</code>
  casting to specify the type of the variable:</p>
  
  <pre><code>$number = [int]10</code></pre>

  <h3>Variable Scope</h3>
  
  <p>Variables in PowerShell have different scopes, such as global, local,
    and script. The scope determines the visibility of the variable within
    different parts of the script or session:</p>
  
  <pre><code>
  $global:variable = "I am global"
  $local:variable = "I am local"
  </code></pre>

  <h2>Path Normalization</h2>
  
  <p>Path normalization ensures that paths are converted to a standard format,
    making them consistent and usable. In PowerShell, you can handle path
    normalization using various cmdlets and methods:</p>

  <h3>Resolve-Path Cmdlet</h3>
  
  <p>The <code>Resolve-Path</code> cmdlet is used to get the full path of
    a specified item. This cmdlet is useful for resolving relative paths
    to absolute paths:</p>
  
  <pre><code>Resolve-Path .\myfile.txt</code></pre>
  
  <p>This command returns the full path of <code>myfile.txt</code> relative
    to the current directory.</p>

  <h3>Using <code>[System.IO.Path]</code></h3>
  
  <p>The .NET class <code>[System.IO.Path]</code> provides methods to handle
    and normalize paths:</p>
  
  <pre><code>[System.IO.Path]::GetFullPath(".\myfile.txt")</code></pre>
  
  <p>This method returns the absolute path of the specified file.</p>

  <h3>Combining Paths</h3>
  
  <p>You can combine paths using the <code>Join-Path</code> cmdlet:</p>
  
  <pre><code>Join-Path "C:\Users\John" "Documents\file.txt"</code></pre>
  
  <p>This will return the combined path <code>C:\Users\John\Documents\file.txt</code>.</p>

  <h2>Regex Parsing</h2>
  
  <p>Regular expressions (regex) are used to search and manipulate strings
    based on patterns. PowerShell supports regex operations through its
    operators and methods:</p>

  <h3>Matching Patterns</h3>
  
  <p>The <code>-match</code> operator is used to test if a string matches
    a regex pattern. It returns <code>$true</code> if the pattern is found:</p>
  
  <pre><code>
    $string = "The quick brown fox"
  if ($string -match "quick") {
      Write-Output "Pattern matched!"
  }
  </code></pre>

  <h3>Extracting Matches</h3>
  
  <p>You can extract matched groups using the <code>Match</code> object returned
    by the <code>-match</code> operator:</p>
  
  <pre><code>
    $string = "Date: 2024-09-14"
  if ($string -match "(\d{4})-(\d{2})-(\d{2})") {
      $year = $matches[1]
      $month = $matches[2]
      $day = $matches[3]
      Write-Output "Year: $year, Month: $month, Day: $day"
  }
  </code></pre>

  <h3>Replacing Patterns</h3>
  
  <p>The <code>-replace</code> operator is used to replace text that matches
    a regex pattern:</p>
  
  <pre><code>
  $string = "Hello World"
  $newString = $string -replace "World", "PowerShell"
  Write-Output $newString
  </code></pre>
  
  <p>This command replaces <code>World</code> with <code>PowerShell</code>,
    resulting in <code>Hello PowerShell</code>.</p>

  <h2>Setting Execution Policy</h2>
  
  <p>Before running scripts in PowerShell, you may need to set the execution
    policy. The execution policy determines the conditions under which
    PowerShell loads configuration files and runs scripts. You can set
    the execution policy to allow script execution with the following command:</p>
  
  <pre><code>Set-ExecutionPolicy Bypass -Scope Process -Force</code></pre>
  
  <p>This command sets the execution policy to <code>Bypass</code> for the
    current PowerShell session, allowing scripts to run without restriction.
    The <code>-Scope Process</code> option ensures that the policy is applied
    only to the current process, and <code>-Force</code> suppresses confirmation
    prompts.</p>

  <h2>Executing Scripts</h2>
  
  <p>To execute a PowerShell script, use the following command:</p>
  
  <pre><code>.\scriptname.ps1</code></pre>
  
  <p>Replace <code>scriptname.ps1</code> with the name of your PowerShell
    script. Make sure you are in the directory where the script is located.</p>

  <p>You also could provide the full path to the script:</p>
  
  <pre><code>C:\Users\User\Downloads\scriptname.ps1</code></pre>
  
  <h2>Comparison: PowerShell and UNIX (Linux/macOS)</h2>
  
  <table>
    <thead>
      <tr>
        <th>Feature</th>
        <th>PowerShell</th>
        <th>UNIX (Linux/macOS)</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Script File Extension</td>
        <td>.ps1</td>
        <td>.sh</td>
      </tr>
      <tr>
        <td>Execution Command</td>
        <td>.\scriptname.ps1</td>
        <td>./scriptname.sh</td>
      </tr>
      <tr>
        <td>Execution Policy</td>
        <td>Set-ExecutionPolicy</td>
        <td>chmod +x</td>
      </tr>
      <tr>
        <td>Shebang Line</td>
        <td>No shebang needed</td>
        <td>#!/bin/bash</td>
      </tr>
      <tr>
        <td>Environment Variable</td>
        <td>$env:VARIABLE</td>
        <td>$VARIABLE</td>
      </tr>
      <tr>
        <td>Path Separator</td>
        <td>\ (Backslash)</td>
        <td>/ (Forward Slash)</td>
      </tr>
      <tr>
        <td>Current Directory</td>
        <td>.\ (dot backslash)</td>
        <td>./ (dot slash)</td>
      </tr>
      <tr>
        <td>Home Directory</td>
        <td>$HOME</td>
        <td>~ (tilde)</td>
      </tr>
      <tr>
        <td>Variable Declaration</td>
        <td>$var = "value"</td>
        <td>var="value"</td>
      </tr>
      <tr>
        <td>Regular Expression Matching</td>
        <td>$string -match "pattern"</td>
        <td>grep "pattern" $string</td>
      </tr>
      <tr>
        <td>Path Normalization</td>
        <td>Resolve-Path</td>
        <td>realpath</td>
      </tr>
      <tr>
        <td>String Concatenation</td>
        <td>"$string1$string2"</td>
        <td>$string1$string2</td>
      </tr>
      <tr>
        <td>Command Output Redirection</td>
        <td>Out-File or > operator</td>
        <td> > operator</td>
      </tr>
    </tbody>
  </table>

  <h3>References</h3>
  
  <ul>
    <li><a href="https://github.com/janikvonrotz/awesome-powershell" target="_blank">Awesome PowerShell</a> - A curated list of delightful PowerShell modules and resources on GitHub.</li>
    <li><a href="https://learn.microsoft.com/en-us/?view=powershell-7.4"
      target="_blank">Microsoft PowerShell Learn</a></li>
    <li><a href="https://github.com/PowerShell/PSReadLine"
      target="_blank">PowerShell PSReadLine</a> - A bash inspired readline implementation for PowerShell</li>
    <li><a href="https://github.com/PowerShell/PowerShell/issues" target="_blank">PowerShell Issues</a> on GitHub.</li>
     <li><a href="https://learn.microsoft.com/en-us/powershell/scripting/overview?view=ps1.0"
      target="_blank">Microsoft PowerShell Overview</a> - An overview of
      PowerShell with links to more in-depth learning materials.</li>
    <li><a href="https://docs.microsoft.com/en-us/powershell/" target="_blank">Microsoft PowerShell Documentation</a>
      - Official documentation from Microsoft providing comprehensive information
      on PowerShell features and cmdlets.</li>
  </ul>
  
  <h3>Cheat Sheets</h3>
  <ul>
    <li><a href="https://ss64.com/ps/" target="_blank">SS64 PowerShell Cheat Sheet</a>
      - A handy cheat sheet for quick reference to common PowerShell commands
      and syntax.</li>
    <li><a href="https://pscheatsheet.netlify.app/" target="_blank">PowerShell Cheat Sheet</a>
      - Another useful cheat sheet for common PowerShell commands and usage
      examples.</li>
  </ul>

</body>
</html>