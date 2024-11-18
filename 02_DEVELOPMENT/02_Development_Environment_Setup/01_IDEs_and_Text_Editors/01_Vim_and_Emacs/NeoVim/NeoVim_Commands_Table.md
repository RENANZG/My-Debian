<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vim Cheatsheet</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
        border: 1px solid black;
    }
    th, td {
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
</style>
</head>
<body>
<h3>Vim Cheatsheet (<a href="https://neovim.io/doc/user/quickref.html">Quick Reference</a>)</h3>
<table>
    <tr>
        <th>Key</th>
        <th>Command</th>
        <th>Key</th>
        <th>Command</th>
    </tr>
    <!-- Moving Around -->
    <tr>
        <td>h</td>
        <td>Move cursor left</td>
        <td>j</td>
        <td>Move cursor down</td>
    </tr>
    <tr>
        <td>k</td>
        <td>Move cursor up</td>
        <td>l</td>
        <td>Move cursor right</td>
    </tr>
    <tr>
        <td>0</td>
        <td>Move cursor to beginning of line</td>
        <td>^</td>
        <td>Move cursor to first non-whitespace character of line</td>
    </tr>
    <tr>
        <td>$</td>
        <td>Move cursor to end of line</td>
        <td>gg</td>
        <td>Move cursor to beginning of the file</td>
    </tr>
    <tr>
        <td>G</td>
        <td>Move cursor to end of the file</td>
        <td>5G</td>
        <td>Move cursor to line number 5</td>
    </tr>
    <!-- File Management -->
    <tr>
        <td>:e filename</td>
        <td>Open file for editing</td>
        <td>:w</td>
        <td>Save current buffer to disk</td>
    </tr>
    <tr>
        <td>:w filename</td>
        <td>Save current buffer to filename</td>
        <td>:q</td>
        <td>Close the current window</td>
    </tr>
    <tr>
        <td>:wq</td>
        <td>Save and close the current window</td>
        <td>:q!</td>
        <td>Close the current window without saving</td>
    </tr>
    <tr>
        <td>:wa</td>
        <td>Save all open buffers to disk</td>
        <td></td>
        <td></td>
    </tr>
    <!-- Editing Commands I -->
    <tr>
        <td>i</td>
        <td>Enter Insert mode before the cursor</td>
        <td>a</td>
        <td>Enter Insert mode after the cursor</td>
    </tr>
    <tr>
        <td>I</td>
        <td>Enter Insert mode at beginning of the line</td>
        <td>A</td>
        <td>Enter Insert mode at the end of the line</td>
    </tr>
    <tr>
        <td>o</td>
        <td>Insert a new line below the current line and enter Insert mode</td>
        <td>O</td>
        <td>Insert a new line above the current line and enter Insert mode</td>
    </tr>
    <!-- Editing Commands II -->
    <tr>
        <td>dd</td>
        <td>Delete the current line</td>
        <td>D</td>
        <td>Delete from the cursor to the end of the line</td>
    </tr>
    <tr>
        <td>C</td>
        <td>Change from the cursor to the end of the line and enter Insert mode</td>
        <td>u</td>
        <td>Undo the last change</td>
    </tr>
    <tr>
        <td>cw</td>
        <td>Change from cursor to end of word and enter Insert mode</td>
        <td>cb</td>
        <td>Change from cursor to beginning of word and enter Insert mode</td>
    </tr>
    <!-- Visual Mode Commands -->
    <tr>
        <td>v</td>
        <td>Enter Visual mode and select text character by character</td>
        <td>V</td>
        <td>Enter Visual mode and select text line by line</td>
    </tr>
    <tr>
        <td>y</td>
        <td>Yank (copy) the selected line</td>
        <td>d</td>
        <td>Delete the selected text</td>
    </tr>
    <tr>
        <td>c</td>
        <td>Change the selected text and enter Insert mode</td>
        <td></td>
        <td></td>
    </tr>
    <!-- Search and Replace -->
    <tr>
        <td>/pattern</td>
        <td>Search forward for a pattern</td>
        <td>?pattern</td>
        <td>Search backward for a pattern</td>
    </tr>
    <tr>
        <td>n</td>
        <td>Repeat the last search in the same direction</td>
        <td>N</td>
        <td>Repeat the last search in the opposite direction</td>
    </tr>
    <tr>
        <td>:%s/pattern/replacement/g</td>
        <td>Replace all occurrences of 'pattern' with 'replacement' in the entire file</td>
        <td></td>
        <td></td>
    </tr>
    <!-- Macros and Registers -->
    <tr>
        <td>qa</td>
        <td>Start recording a macro in register 'a'</td>
        <td>q</td>
        <td>Stop recording a macro</td>
    </tr>
    <tr>
        <td>@a</td>
        <td>Execute the macro stored in register 'a'</td>
        <td>"</td>
        <td>Access a specific register</td>
    </tr>
    <tr>
        <td>"ay</td>
        <td>Yank into register 'a'</td>
        <td></td>
        <td></td>
    </tr>
    <!-- Splits and Tabs -->
    <tr>
        <td>:sp</td>
        <td>Split the window horizontally</td>
        <td>:vsp</td>
        <td>Split the window vertically</td>
    </tr>
    <tr>
        <td>:tabe</td>
        <td>Create a new tab</td>
        <td>:tabc</td>
        <td>Close the current tab</td>
    </tr>
    <tr>
        <td>:tabn</td>
        <td>Go to the next tab</td>
        <td>:tabp</td>
        <td>Go to the previous tab</td>
    </tr>
</table>
</body>
</html>
