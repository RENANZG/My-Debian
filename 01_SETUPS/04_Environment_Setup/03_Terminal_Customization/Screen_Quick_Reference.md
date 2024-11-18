<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SCREEN Quick Reference</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        td[colspan="2"] {
            background-color: #f9f9f9;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h4>SCREEN Quick Reference</h4>

    <table>
        <thead>
            <tr>
                <th>Shortcut</th>
                <th>Action</th>
                <th>Shortcut</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>screen -S &lt;name&gt;</code></td>
                <td>Start new screen session</td>
                <td><code>C-a |</code></td>
                <td>Vertical split (panes side by side)</td>
            </tr>
            <tr>
                <td><code>screen -ls</code></td>
                <td>List running sessions/screens</td>
                <td><code>C-a S</code></td>
                <td>Horizontal split (one pane below the other)</td>
            </tr>
            <tr>
                <td><code>screen -x</code></td>
                <td>Join a session without detaching</td>
                <td><code>C-a Q</code></td>
                <td>Clear all splits</td>
            </tr>
            <tr>
                <td><code>C-a d</code></td>
                <td>Detach from a session, leaving it running in the background</td>
                <td><code>C-a &lt;Tab&gt;</code></td>
                <td>Move to next split</td>
            </tr>
            <tr>
                <td><code>C-a k</code></td>
                <td>Exit and quit screen session</td>
                <td><code>C-a c</code></td>
                <td>Create new window</td>
            </tr>
            <tr>
                <td><code>C-a m</code></td>
                <td>Monitor window for activity</td>
                <td><code>C-a n</code></td>
                <td>Move to next window</td>
            </tr>
            <tr>
                <td><code>C-a x</code></td>
                <td>Lock screen</td>
                <td><code>C-a p</code></td>
                <td>Move to previous window</td>
            </tr>
            <tr>
                <td><code>C-a A</code></td>
                <td>Set window title</td>
                <td><code>C-a NUM</code></td>
                <td>Move to window NUM</td>
            </tr>
            <tr>
                <td><code>C-a i</code></td>
                <td>Get info about current window</td>
                <td><code>C-a '</code></td>
                <td>Prompt to move to window</td>
            </tr>
       </tbody>        
       </table>
       
</body>
</html>