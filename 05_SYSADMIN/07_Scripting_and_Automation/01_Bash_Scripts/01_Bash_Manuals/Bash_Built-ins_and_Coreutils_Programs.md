<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bash Built-ins and Coreutils Programs</title>
  <style>
    @page {
      size: A4 landscape;
      margin: 10mm;
    }
    body {
      font-family: Arial, sans-serif;
      line-height: 1.2;
      margin: 0;
    }
    h2 {
      text-align: center;
      color: #333;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
      margin-bottom: 20px;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 5px;
      text-align: left;
      vertical-align: top;
    }
    th {
      background-color: #f4f4f4;
    }
    ul {
      list-style-type: none;
      padding: 0;
      margin: 0;
    }
    ul li {
      background: #f9f9f9;
      margin: 2px 0;
      padding: 2px;
      border: 1px solid #ddd;
    }
  </style>
</head>
<body>
  
  <table>
    <thead>
      <tr>
        <th>Bash Built-ins</th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>
          <ul>
            <li>alias</li>
            <li>bg</li>
            <li>bind</li>
            <li>break</li>
            <li>builtin</li>
            <li>cd</li>
            <li>command</li>
            <li>compgen</li>
            <li>complete</li>
            <li>compopt</li>
            <li>continue</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>declare</li>
            <li>dirs</li>
            <li>disown</li>
            <li>echo</li>
            <li>enable</li>
            <li>eval</li>
            <li>exec</li>
            <li>exit</li>
            <li>export</li>
            <li>fc</li>
            <li>fg</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>getopts</li>
            <li>hash</li>
            <li>help</li>
            <li>history</li>
            <li>jobs</li>
            <li>kill</li>
            <li>let</li>
            <li>local</li>
            <li>logout</li>
            <li>mapfile</li>
            <li>popd</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>printf</li>
            <li>pushd</li>
            <li>pwd</li>
            <li>read</li>
            <li>readarray</li>
            <li>readonly</li>
            <li>return</li>
            <li>set</li>
            <li>shift</li>
            <li>shopt</li>
            <li>source</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>suspend</li>
            <li>test</li>
            <li>times</li>
            <li>trap</li>
            <li>type</li>
            <li>typeset</li>
            <li>ulimit</li>
            <li>umask</li>
            <li>unalias</li>
            <li>unset</li>
            <li>wait</li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>
  
  <table>
    <thead>
      <tr>
        <th>GNU Coreutils Programs</th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>
          <ul>
            <li>arch</li>
            <li>base32</li>
            <li>base64</li>
            <li>basename</li>
            <li>cat</li>
            <li>chcon</li>
            <li>chgrp</li>
            <li>chmod</li>
            <li>chown</li>
            <li>chroot</li>
            <li>cksum</li>
            <li>comm</li>
            <li>cp</li>
            <li>csplit</li>
            <li>cut</li>
            <li>date</li>
            <li>dd</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>df</li>
            <li>dir</li>
            <li>dircolors</li>
            <li>dirname</li>
            <li>du</li>
            <li>echo</li>
            <li>env</li>
            <li>expand</li>
            <li>expr</li>
            <li>factor</li>
            <li>false</li>
            <li>fmt</li>
            <li>fold</li>
            <li>groups</li>
            <li>head</li>
            <li>hostid</li>
            <li>id</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>install</li>
            <li>join</li>
            <li>link</li>
            <li>ln</li>
            <li>logname</li>
            <li>ls</li>
            <li>md5sum</li>
            <li>mkdir</li>
            <li>mkfifo</li>
            <li>mknod</li>
            <li>mktemp</li>
            <li>mv</li>
            <li>nice</li>
            <li>nl</li>
            <li>nohup</li>
            <li>nproc</li>
            <li>numfmt</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>od</li>
            <li>paste</li>
            <li>pathchk</li>
            <li>pinky</li>
            <li>pr</li>
            <li>printenv</li>
            <li>printf</li>
            <li>ptx</li>
            <li>pwd</li>
            <li>readlink</li>
            <li>realpath</li>
            <li>rm</li>
            <li>rmdir</li>
            <li>runcon</li>
            <li>seq</li>
            <li>sha1sum</li>
            <li>sha224sum</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>sha256sum</li>
            <li>sha384sum</li>
            <li>sha512sum</li>
            <li>shred</li>
            <li>shuf</li>
            <li>sleep</li>
            <li>sort</li>
            <li>split</li>
            <li>stat</li>
            <li>stty</li>
            <li>sum</li>
            <li>sync</li>
            <li>tac</li>
            <li>tail</li>
            <li>tee</li>
            <li>test</li>
            <li>timeout</li>
          </ul>
        </td>
        <td>
          <ul>
            <li>touch</li>
            <li>tr</li>
            <li>true</li>
            <li>truncate</li>
            <li>tsort</li>
            <li>tty</li>
            <li>uname</li>
            <li>unexpand</li>
            <li>uniq</li>
            <li>unlink</li>
            <li>uptime</li>
            <li>users</li>
            <li>vdir</li>
            <li>wc</li>
            <li>who</li>
            <li>whoami</li>
            <li>yes</li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>
</body>

</html>