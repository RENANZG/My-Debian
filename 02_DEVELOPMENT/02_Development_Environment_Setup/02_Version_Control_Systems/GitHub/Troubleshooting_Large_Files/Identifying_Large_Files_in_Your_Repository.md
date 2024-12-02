<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Identifying Large Files in Your Repository</title>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    h1 {
      color: #333;
    }
    pre {
      background: #f4f4f4;
      padding: 10px;
      border: 1px solid #ddd;
      overflow-x: auto;
    }
</style>
</head>
<body>
  
<h2>Identifying Large Files in Your Repository</h2>

<p>To identify large files in your repository that might be causing issues, use the following commands:</p>

<h3>Verifing the size of your local Git directory</h3>

<p>Verify the size of your local Git directory:</p>
<pre><code>du -sh .git</code></pre>

<h3>Check File Sizes in the Working Directory</h3>
<pre>du -sh *</pre>
<p>This command shows the sizes of all files and directories in the current directory.</p>

<h3>Check Total Repository Size</h3>
<pre>git count-objects -vH</pre>
<p>This provides a detailed view of the size of your repository, including the number of objects and the total size in a human-readable format.</p>

<h3>Estimate Size of Changes</h3>
<pre>du -sh path/to/file</pre>
<p>This allows you to check the size of specific files before adding them to your repository.</p>

<h3>Monitor Repository Size</h3>
<pre>git count-objects -vH</pre>
<p>Re-running this command after cleanup or after significant changes will help you monitor your repository size over time.</p>

<h3>Finding Large Files in the Working Directory</h3>
<pre><code>find . -type f -exec du -h {} + | sort -rh | head -n 10</code></pre>
<p>This command shows the top 10 largest files in the current directory and subdirectories, sorted by size.</p>

<h3>Finding Large Objects in Your Git History</h3>
<pre><code>git rev-list --objects --all |
  git cat-file --batch-check='%(objectname) %(objecttype) %(rest)' |
  grep blob |
  cut -d' ' -f1 |
  xargs -n1 git ls-tree --full-name --abbrev=40 -r |
  sort -r -n -k3 |
  head -n 10</code></pre>
<p>This command helps you find the largest objects in your Git history and identify files that may be taking up too much space.</p>


</body>
</html>
