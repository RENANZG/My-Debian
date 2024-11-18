<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Compression Algorithm Comparison</title>
<style>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #ccc;
    padding: 8px;
    text-align: left;
  }
  th {
    background-color: #f2f2f2;
  }
</style>
<script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>
</head>
<body>

<h2>Compression Algorithm Comparison</h2>
<table class="sortable">
<thead>
  <tr>
    <th>Compression Algorithm</th>
    <th>Common Use Case</th>
    <th>Supported File Formats</th>
    <th>1GB File (Before &amp; After)</th>
    <th>Compression Ratio</th>
    <th>Compression Speed (MB/s)</th>
    <th>Decompression Speed (MB/s)</th>
    <th>Multicore Support</th>
    <th>Resource Intensive</th>
    <th>Error Recovery</th>
    <th>Algorithm Complexity</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>No compression</td>
    <td>When speed is more important than space</td>
    <td>N/A</td>
    <td>1GB &rarr; 1GB</td>
    <td>N/A</td>
    <td>1000 MB/s</td>
    <td>N/A</td>
    <td>N/A</td>
    <td>Low</td>
    <td>None</td>
    <td>Low</td>
  </tr>
  <tr>
    <td><a href="https://en.wikipedia.org/wiki/DEFLATE">DEFLATE (used by zlib/gzip)</a></td>
    <td>General-purpose compression</td>
    <td>gz, tar.gz</td>
    <td>1GB &rarr; 370MB</td>
    <td>2.7:1</td>
    <td>50-100 MB/s</td>
    <td>150-250 MB/s</td>
    <td>No</td>
    <td>Low</td>
    <td>Basic</td>
    <td>Low</td>
  </tr>
  <tr>
    <td><a href="https://www.zlib.net/pigz/">Parallel DEFLATE (e.g., pigz)</a></td>
    <td>General-purpose compression with multicore support</td>
    <td>gz, tar.gz</td>
    <td>1GB &rarr; 370MB</td>
    <td>2.7:1</td>
    <td>150-200 MB/s</td>
    <td>250-400 MB/s</td>
    <td>Yes</td>
    <td>Medium</td>
    <td>Basic</td>
    <td>Low</td>
  </tr>
  <tr>
    <td><a href="https://en.wikipedia.org/wiki/Bzip2">BZIP2</a></td>
    <td>High compression ratio for archives</td>
    <td>bz2, tar.bz2</td>
    <td>1GB &rarr; 330MB</td>
    <td>3.0:1</td>
    <td>5-10 MB/s</td>
    <td>20-50 MB/s</td>
    <td>No</td>
    <td>Medium</td>
    <td>Moderate</td>
    <td>Medium</td>
  </tr>
  <tr>
    <td><a href="http://compression.ca/pbzip2/">Parallel BZIP2 (e.g., pbzip2)</a></td>
    <td>High compression ratio for archives with multicore support</td>
    <td>bz2, tar.bz2</td>
    <td>1GB &rarr; 330MB</td>
    <td>3.0:1</td>
    <td>20-50 MB/s</td>
    <td>50-100 MB/s</td>
    <td>Yes</td>
    <td>Medium</td>
    <td>Moderate</td>
    <td>Medium</td>
  </tr>
  <tr>
    <td><a href="https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%2FOrder_0_LZ77">LZO</a></td>
    <td>Realtime compression</td>
    <td>tar.lzo</td>
    <td>1GB &rarr; 480MB</td>
    <td>2.1:1</td>
    <td>400-500 MB/s</td>
    <td>800-1000 MB/s</td>
    <td>No</td>
    <td>Low</td>
    <td>Basic</td>
    <td>Low</td>
  </tr>
  <tr>
    <td><a href="https://en.wikipedia.org/wiki/LZMA">LZMA (7z, xz)</a></td>
    <td>Maximum compression for archives</td>
    <td>7z, tar.xz</td>
    <td>1GB &rarr; 250MB</td>
    <td>4.0:1</td>
    <td>5-10 MB/s</td>
    <td>20-30 MB/s</td>
    <td>No</td>
    <td>High</td>
    <td>Good</td>
    <td>High</td>
  </tr>
  <tr>
    <td><a href="https://en.wikipedia.org/wiki/LZMA">LZMA2 (7z, xz)</a></td>
    <td>Maximum compression for archives with multicore support</td>
    <td>7z, tar.xz</td>
    <td>1GB &rarr; 220MB</td>
    <td>4.5:1</td>
    <td>10-20 MB/s</td>
    <td>20-30 MB/s</td>
    <td>Yes</td>
    <td>High</td>
    <td>Good</td>
    <td>High</td>
  </tr>
  <tr>
    <td><a href="https://tukaani.org/xz/">Xz (single-core)</a></td>
    <td>Maximum compression for archives</td>
    <td>xz, tar.xz</td>
    <td>1GB &rarr; 250MB</td>
    <td>4.0:1</td>
    <td>5-10 MB/s</td>
    <td>20-30 MB/s</td>
    <td>No</td>
    <td>High</td>
    <td>Good</td>
    <td>High</td>
  </tr>
  <tr>
    <td><a href="https://tukaani.org/xz/">Parallel XZ</a></td>
    <td>Maximum compression for archives with multicore support</td>
    <td>xz, tar.xz</td>
    <td>1GB &rarr; 250MB</td>
    <td>4.0:1</td>
    <td>20-50 MB/s</td>
    <td>40-100 MB/s</td>
    <td>Yes</td>
    <td>High</td>
    <td>Good</td>
    <td>High</td>
  </tr>
  <tr>
    <td><a href="https://lz4.github.io/lz4/">LZ4</a></td>
    <td>Realtime compression with fast speed</td>
    <td>lz4</td>
    <td>1GB &rarr; 480MB</td>
    <td>2.1:1</td>
    <td>400-500 MB/s</td>
    <td>800-1000 MB/s</td>
    <td>Yes</td>
    <td>Low</td>
    <td>Basic</td>
    <td>Low</td>
  </tr>
  <tr>
    <td><a href="https://facebook.github.io/zstd/">Zstandard (zstd)</a></td>
    <td>General-purpose compression with fast speed</td>
    <td>zst</td>
    <td>1GB &rarr; 350MB</td>
    <td>2.9:1</td>
    <td>200-300 MB/s</td>
    <td>400-500 MB/s</td>
    <td>Yes</td>
    <td>Medium</td>
    <td>Good</td>
    <td>Medium</td>
  </tr>
</tbody>
</table>

<h3>References</h3>
<ul>
  <li><a href="https://www.cio.com/article/295035/the-best-compression-tools-and-algorithms.html">CIO - The Best Compression Tools and Algorithms</a></li>
  <li><a href="https://www.linpack.org/misc/compression.html">Linpack - Compression Algorithms Overview</a></li>
  <li><a href="https://www.zdnet.com/article/best-compression-tools-for-windows-2021/">ZDNet - Best Compression Tools for Windows</a></li>
  <li><a href="https://tukaani.org/xz/">XZ Utils Documentation</a></li>
  <li><a href="https://github.com/Parallel-LZMA/parallel-lzma">Parallel LZMA GitHub Repository</a></li>
</ul>

</body>
</html>
