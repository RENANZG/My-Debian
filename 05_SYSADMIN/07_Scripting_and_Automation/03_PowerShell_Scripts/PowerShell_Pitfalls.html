<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PowerShell Overview</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            background-color: #f9f9f9;
        }
        h1, h2, h3 {
            color: #2c3e50;
        }
        pre {
            background: #f8f8f8;
            padding: 10px;
            border: 1px solid #ddd;
            overflow: auto;
            border-radius: 5px;
        }
        ul {
            list-style-type: disc;
            margin-left: 20px;
        }
    </style>
</head>
<body>

    <h1>Overview of PowerShell Commands</h1>

    <h2>Argument Parsing in PowerShell</h2>
    <p>PowerShell uses several metacharacters that influence how command arguments are parsed. Understanding these is crucial for effective scripting.</p>

    <h3>Key Metacharacters</h3>
    <ul>
        <li><strong>Space</strong></li>
        <li><strong>Single Quote (')</strong></li>
        <li><strong>Double Quote (")</strong></li>
        <li><strong>Backtick (`)</strong></li>
        <li><strong>Comma (,)</strong></li>
        <li><strong>Semicolon (;)</strong></li>
        <li><strong>Parentheses (())</strong></li>
        <li><strong>Curly Braces ({})</strong></li>
        <li><strong>Pipe (|)</strong></li>
        <li><strong>At Symbol (@)</strong></li>
        <li><strong>Hash (#)</strong></li>
        <li><strong>Less Than (&lt;)</strong></li>
        <li><strong>Greater Than (&gt;)</strong></li>
    </ul>

    <h3>Using the Stop-Parsing Token (--%)</h3>
    <p>The <code>--%</code> token prevents PowerShell from parsing the rest of the command, making it useful for passing commands to external executables. Note that it has limitations, such as the inability to use PowerShell variables.</p>

    <h3>Escaping Metacharacters</h3>
    <p>To use metacharacters literally at the start of an argument, you can:</p>
    <ul>
        <li>Enclose them in quotes:</li>
        <pre>pnpm dlx '@trigger.dev/cli@latest' init -k tr_dev_1213241234zxcz -t https://cloud.trigger.dev</pre>
        <li>Escape with a backtick:</li>
        <pre>pnpm dlx `@trigger.dev/cli@latest init -k tr_dev_1213241234zxcz -t https://cloud.trigger.dev</pre>
    </ul>

    <h3>Compound Strings and Variable References</h3>
    <p>When using variable references within strings, it's recommended to use double quotes ("...") to ensure proper interpretation. This avoids pitfalls where variables are treated as separate arguments.</p>
    <h4>Examples:</h4>
    <pre>Write-Output "$HOME/projects"</pre>
    <pre>Write-Output $HOME\Desktop</pre>

    <h3>Disambiguating Variable Names</h3>
    <p>To clarify variable references followed by additional characters, enclose the variable name in curly braces:</p>
    <pre>Write-Output ${HOME}folder</pre>

    <h3>Expression Contexts</h3>
    <p>Certain tokens create a new parsing context:</p>
    <ul>
        <li><code>()</code> for a single expression.</li>
        <li><code>$(...) </code> for multiple expressions.</li>
        <li><code>@(...) </code> to ensure output is treated as an array.</li>
    </ul>

    <h3>Common Pitfalls</h3>
    <p>Be cautious of how expressions and variables are interpreted. For instance:</p>
    <ul>
        <li>Using <code>$(...) </code> at the start of an argument will be treated as a separate argument.</li>
        <li>Using <code>.</code> immediately followed by a variable reference can lead to unexpected behavior.</li>
    </ul>

    <h3>Examples of PowerShell Commands</h3>
    <h4>Valid Uses:</h4>
    <pre>Write-Output 1..10                # STRING: -> '1..10'</pre>
    <pre>Write-Output (1..10)              # EXPRESSION: -> @(1, 2, ...)</pre>
    <pre>Write-Output [Environment]::Version # STRING: -> '[Environment]::Ticks'</pre>
    <pre>Write-Output ([Environment]::Version) # EXPRESSION: -> a [System.Version] instance.</pre>
    <pre>Write-Output $HOME\Desktop         # EXPANDED string (e.g.) 'C:\Users\jdoe\Desktop'</pre>
    
    <h4>Common Issues:</h4>
    <pre>Write-Output $($PSVersionTable.PSVersion)/more # $(...) at the *start*</pre>
    <pre>Write-Output .$HOME                        # Specifically, .$ at the beginning is the problem; escaping . works</pre>

    <h4>References</h4>
    <p>https://stackoverflow.com/a/41254359</p>

</body>
</html>
