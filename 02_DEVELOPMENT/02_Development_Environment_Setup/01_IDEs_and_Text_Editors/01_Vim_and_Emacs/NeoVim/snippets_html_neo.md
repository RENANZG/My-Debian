<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Install UltiSnips in NeoVim</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
        }
        pre {
            background-color: #f4f4f4;
            padding: 10px;
            border: 1px solid #ddd;
            overflow-x: auto;
        }
        h4, h5 {
            color: #333;
        }
    </style>
</head>
<body>
    <h4>Install UltiSnips using your favorite plugin manager for NeoVim (snippets.nvim is another popular snippet plugin).</h4>

    <h5>For example, if you're using vim-plug, you would add the following line to your init.vim or init.lua:</h5>

    <pre>
Plug 'SirVer/ultisnips'
or
Plug 'norcalli/snippets.nvim'
    </pre>

    <h5>Then, reload your configuration (:source %) and install the plugin (:PlugInstall).</h5>

    <h5>Create or edit a file where you define your snippets:</h5>

    <pre>
touch ~/.config/nvim/UltiSnips/html.snippets
or
touch ~/.config/nvim/snippets/html.snippets
    </pre>

    <h5>Example UltiSnips:</h5>

    <pre>
snippet html5 "HTML5 basic structure" b
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${1:Document}</title>
</head>
<body>
     ${0}
</body>
</html>
endsnippet
    </pre>

    <h5>Example snippets.nvim:</h5>

    <pre>
local snippets = require('snippets')

snippets.snippets = {
    html5 = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${1:Document}</title>
</head>
<body>
    ${0}
</body>
</html>
]],
}
    </pre>
    
</body>
</html>
