<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Using AWS S3 for Data Backup on Linux</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      padding: 20px;
      background-color: #f4f4f4;
    }
    h1, h2 {
      color: #333;
    }
    code {
      background-color: #e9ecef;
      padding: 2px 4px;
      border-radius: 4px;
    }
    pre {
      background-color: #e9ecef;
      padding: 10px;
      overflow-x: auto;
    }
    a {
      color: #007bff;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    .note {
      background-color: #fffae6;
      border-left: 4px solid #ffc107;
      padding: 10px;
      margin: 20px 0;
    }
</style>
</head>
<body>

<h2>Using AWS S3 for Data Backup on Linux</h2>
<p>If you're looking for a reliable way to back up your data, Amazon S3 (Simple Storage Service) is a great alternative to services like Google Drive or MegaSync. This guide will help you set up your AWS S3 bucket on your Linux system using <code>s3fs</code>, making it easy to manage your files as if they were on your local computer.</p>

<h2>Understanding Costs</h2>
<p>Before you begin, it's important to know how much using AWS S3 will cost you. Check out the following links for pricing information and to estimate your costs:</p>
<ul>
  <li><a href="https://aws.amazon.com/s3/pricing/">AWS S3 Pricing</a></li>
  <li><a href="https://calculator.aws/#/createCalculator/S3">AWS Pricing Calculator</a></li>
</ul>

<h2>Mounting an AWS S3 Bucket Using <code>s3fs</code></h2>
<p><code>s3fs</code> allows you to mount your S3 bucket as if it were part of your local file system. Follow these steps to set it up:</p>

<h3>Step 1: Switch to the Root User</h3>
<p>Open your terminal and switch to the root user:</p>
<pre><code>sudo su -</code></pre>

<h3>Step 2: Install <code>s3fs</code></h3>
<p>Install the <code>s3fs</code> package using the following command:</p>
<pre><code>apt-get install -y s3fs</code></pre>

<h3>Step 3: Set Up Your AWS Credentials</h3>
<p>Create a file to store your AWS credentials. Use the following command:</p>
<pre><code>echo AWS_ACCESS_KEY_ID:AWS_SECRET_ACCESS_KEY &gt; /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs</code></pre>
<p>Make sure to replace <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code> with your actual AWS keys. You can add multiple credentials by placing each on a new line.</p>

<h3>Step 4: Create Directories for Mounting</h3>
<p>Create the directories for your S3 bucket and caching:</p>
<pre><code>mkdir /tmp/cache
mkdir /mnt/s3-bucket
chmod 777 /tmp/cache /mnt/s3-bucket</code></pre>

<h3>Step 5: Mount Your S3 Bucket</h3>
<p>Now, mount your S3 bucket using this command. Replace <code>s3-bucket-name</code> with your bucket's name:</p>
<pre><code>s3fs s3-bucket-name /mnt/s3-bucket -o passwd_file=/etc/passwd-s3fs -o allow_other,use_cache=/tmp/cache</code></pre>

<h3>Step 6: Verify the Mount</h3>
<p>Check if your S3 bucket is mounted correctly:</p>
<pre><code>ls -lrt /mnt/s3-bucket</code></pre>

<h3>Step 7: Mounting as a Regular User</h3>
<p>If you want to mount the S3 bucket as a regular user, run:</p>
<pre><code>s3fs s3-bucket-name /mnt/s3-bucket -o passwd_file=/etc/passwd-s3fs -o allow_other,use_cache=/tmp/cache,uid=1000,umask=077,gid=1000</code></pre>
<p>To find your <code>uid</code> and <code>gid</code>, run:</p>
<pre><code>id ${USER}</code></pre>

<h3>Step 8: Automatic Mounting on Boot</h3>
<p>To have your S3 bucket mount automatically at boot, add this line to your <code>/etc/fstab</code>:</p>
<pre><code>s3fs#s3-bucket-name /mnt/s3-bucket fuse _netdev,rw,nosuid,nodev,allow_other,nonempty,uid=1000,umask=077 0 0</code></pre>
<p>Then, remount all filesystems to apply the changes:</p>
<pre><code>mount -a</code></pre>

<p class="note"><strong>Note:</strong> If you get an error about <code>allow_other</code>, you may need to uncomment the <code>user_allow_other</code> line in <code>/etc/fuse.conf</code>.</p>

<h3>References</h3>
<ul>
  <li><a href="https://sysadminxpert.com/how-to-mount-s3-bucket-on-linux-instance/">How to Mount an S3 Bucket on Linux</a></li>
  <li><a href="https://winscp.net/eng/docs/guide_amazon_s3_sftp#mounting">Guide on Mounting Amazon S3</a></li>
</ul>

</body>
</html>
