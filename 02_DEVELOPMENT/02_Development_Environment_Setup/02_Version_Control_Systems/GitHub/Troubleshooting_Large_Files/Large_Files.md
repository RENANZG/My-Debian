<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Comprehensive Git LFS Guide and Limitations</title>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f4f4f4;
    }
    h1, h2, h3, h4, h5, h6 {
      color: #333;
    }
    p {
      line-height: 1.6;
    }
    pre {
      background-color: #eaeaea;
      padding: 10px;
      border-radius: 5px;
      overflow-x: auto;
    }
    code {
      background-color: #eaeaea;
      padding: 2px 4px;
      border-radius: 3px;
    }
    ul {
      list-style-type: disc;
      padding-left: 20px;
    }
    li {
      margin-bottom: 10px;
    }
</style>
</head>
<body>

<h1>Comprehensive Git LFS Guide: Limits, Installation, and File Management</h1>

<p>This guide covers GitHub file limitations, Git LFS (Large File Storage), managing files in Git LFS, and how to deal with cached large files. If you are working with large files in your repository, understanding these limits and how to work with Git LFS is crucial.</p>

<h2>1. Issues and Limitations with Large Files in GitHub</h2>

<p>GitHub repositories have strict limits on the size of files that can be pushed and managed without Git LFS:</p>

<ul>
  <li><strong>Individual file size limit without Git LFS:</strong> Files larger than <code>100 MB</code> cannot be pushed to GitHub without Git LFS.</li>
  <li><strong>Repository size limit:</strong> Repositories larger than <code>1 GB</code> may experience issues, with soft warnings starting around <code>500 MB</code>.</li>
  <li><strong>GitHub Git LFS bandwidth limits:</strong>
    <ul>
      <li>Free accounts get <code>1 GB</code> of storage and <code>1 GB</code> of bandwidth per month.</li>
      <li>Additional data packs can be purchased, but they come with added costs.</li>
    </ul>
  </li>
</ul>

<p>If you exceed these limits, you’ll need to either delete large files from the repository or use Git LFS to manage them more effectively.</p>

<h3>1.1 Git LFS Bandwidth and Storage Limits</h3>
<ul>
  <li>By default, Git LFS provides <code>1 GB</code> of storage and <code>1 GB</code> of download bandwidth per month.</li>
  <li>If your repository exceeds these limits, GitHub will restrict access to your large files until bandwidth resets or you purchase additional storage.</li>
  <li>Paid GitHub plans provide more storage and bandwidth, but it’s essential to monitor your usage.</li>
</ul>

<h2>2. Installing and Uninstalling Git LFS</h2>

<h3>2.1 Installing Git LFS</h3>
<p>To install Git LFS, run the following commands depending on your platform:</p>

<ul>
  <li><strong>Linux:</strong></li>
  <pre><code>$ sudo apt-get install git-lfs</code></pre>

  <li><strong>macOS (via Homebrew):</strong></li>
  <pre><code>$ brew install git-lfs</code></pre>

  <li><strong>Windows:</strong></li>
  <pre><code>$ choco install git-lfs</code></pre>
</ul>

<p>After installing, initialize Git LFS in your repository:</p>
<pre><code>$ git lfs install</code></pre>

<h3>2.2 Uninstalling Git LFS</h3>
<p>If you want to remove Git LFS from your repository, use the following steps:</p>

<pre><code>$ git lfs uninstall</code></pre>

<p>This will disable LFS for the repository, but files tracked with LFS will remain. To fully remove LFS and bring files back to Git storage, you’ll need to use the <code>git lfs migrate</code> command (explained below).</p>

<h2>3. Managing Large Files with Git LFS</h2>

<p>Once Git LFS is installed, you can start tracking large files. This is how you can work with large files and handle them efficiently.</p>

<h3>3.1 Tracking Large Files with Git LFS</h3>

<p>To track specific file types (like ZIP or PDF files), use the <code>git lfs track</code> command:</p>

<ul>
  <li>Track all ZIP files:</li>
  <pre><code>$ git lfs track "*.zip"</code></pre>

  <li>Track all PDF files:</li>
  <pre><code>$ git lfs track "*.pdf"</code></pre>
</ul>

<p>After tracking files, don’t forget to commit and push the changes:</p>
<pre><code>$ git add .gitattributes
$ git commit -m "Track ZIP and PDF files with Git LFS"
$ git push</code></pre>

<h3>3.2 Untracking Files in Git LFS</h3>

<p>If you no longer want to track certain files with Git LFS, you can untrack them:</p>

<ul>
  <li>Untrack all ZIP files:</li>
  <pre><code>$ git lfs untrack "*.zip"</code></pre>

  <li>Untrack all PDF files:</li>
  <pre><code>$ git lfs untrack "*.pdf"</code></pre>
</ul>

<p>Again, be sure to commit and push the changes:</p>
<pre><code>$ git add .gitattributes
$ git commit -m "Stop tracking ZIP and PDF files with LFS"
$ git push</code></pre>

<h3>3.3 Exporting Files from Git LFS</h3>

<p>If you want to remove files from Git LFS and store them in regular Git storage, you can export them using the <code>git lfs migrate export</code> command:</p>

<ul>
  <li>Export all ZIP files from Git LFS:</li>
  <pre><code>$ git lfs migrate export --include="*.zip"</code></pre>

  <li>Export all PDF files from Git LFS:</li>
  <pre><code>$ git lfs migrate export --include="*.pdf"</code></pre>
</ul>

<p>This process removes files from LFS and moves them back into standard Git storage, freeing up your Git LFS bandwidth and storage limits.</p>

<h2>4. Dealing with Cached Files in Git LFS</h2>

<p>Sometimes, files may remain in the Git LFS cache even after you’ve untracked or exported them. Here’s how to clear the LFS cache.</p>

<h3>4.1 Cleaning the LFS Cache</h3>

<p>To remove unused files from the Git LFS cache, you can run:</p>

<pre><code>$ git lfs prune</code></pre>

<p>This command will clean up LFS-related files that are no longer needed and free up space on your local machine.</p>

<h3>4.2 Checking Git LFS Usage</h3>

<p>If you want to check how much space LFS is taking up, you can run the following command:</p>

<pre><code>$ git lfs ls-files</code></pre>

<p>This will list all the files currently being tracked by Git LFS in your repository.</p>

<h2>5. Troubleshooting Git LFS Issues</h2>

<p>Here are a few common issues with Git LFS and how to solve them:</p>

<ul>
  <li><strong>Error: Repository over LFS quota</strong> – If you receive a message like <code>Repository is over its data quota</code>, you’ve exceeded your Git LFS bandwidth limit. You can either wait for the bandwidth to reset (usually at the start of the next month) or purchase more storage.</li>

  <li><strong>Push rejected due to large files</strong> – If Git rejects a push because your files are too large, check the size of the files and track them with Git LFS if necessary.</li>

  <li><strong>Cannot pull or clone repository</strong> – If you can’t pull from or clone a repository, check your bandwidth and storage limits on GitHub. Exceeding the free Git LFS limit can prevent further downloads.</li>
</ul>

<h2>6. Identifying Large Files in Your Repository</h2>

<p>To identify large files in your repository that might be causing issues, use the following commands:</p>

<h3>6.1 Finding Large Files in the Working Directory</h3>
<pre><code>find . -type f -exec du -h {} + | sort -rh | head -n 10</code></pre>
<p>This command shows the top 10 largest files in the current directory and subdirectories, sorted by size.</p>

<h3>6.2 Finding Large Objects in Your Git History</h3>
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
