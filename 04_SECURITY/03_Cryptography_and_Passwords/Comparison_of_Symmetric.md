<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Comparison of Symmetric Cryptographic Algorithms</title>
<style>
    body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        margin: 20px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #000;
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
    ul {
        margin: 0;
        padding: 0;
        list-style-type: none;
    }
    li {
        margin-bottom: 5px;
    }
</style>
</head>
<body>

<table>
<thead>
<tr>
<th>Basis of Comparison</th>
<th style="text-align: center">DES</th>
<th style="text-align: center">3DES</th>
<th style="text-align: center">AES</th>
<th style="text-align: center">Blowfish</th>
</tr>
</thead>
<tbody>
<tr>
<td>Type</td>
<td>Symmetric (private key)</td>
<td>Symmetric (private key)</td>
<td>Symmetric (private key)</td>
<td>Symmetric (private key)</td>
</tr>
<tr>
<td>Full Form</td>
<td>Data Encryption Standard</td>
<td>Triple Data Encryption Standard</td>
<td>Advanced Encryption Standard</td>
<td>Blowfish</td>
</tr>
<tr>
<td>Plaintext Size</td>
<td>64 bits</td>
<td>64 bits</td>
<td>128, 192, or 256 bits</td>
<td>64 bits</td>
</tr>
<tr>
<td>Ciphertext Size</td>
<td>64 bits</td>
<td>64 bits</td>
<td>128, 192, or 256 bits</td>
<td>64 bits</td>
</tr>
<tr>
<td>Key Length</td>
<td>56 bits (with an additional 8 parity bits)</td>
<td>112 or 168 bits</td>
<td>128, 192, or 256 bits</td>
<td>32 to 448 bits</td>
</tr>
<tr>
<td>Rounds</td>
<td>16</td>
<td>48</td>
<td>10, 12, or 14 depending on key size</td>
<td>16</td>
</tr>
<tr>
<td>Speed</td>
<td>Slower compared to AES</td>
<td>Slower than DES, faster than AES</td>
<td>Faster compared to DES and 3DES</td>
<td>Generally fast</td>
</tr>
<tr>
<td>Applications</td>
<td>Legacy systems, some hardware encryption devices</td>
<td>More secure than DES but slower; used in some legacy systems</td>
<td>Secure communications, financial transactions, data encryption</td>
<td>File encryption, VPNs, password management</td>
</tr>
<tr>
<td>Principle</td>
<td>
Feistel Structure:
<ul>
    <li>Uses a round function (Feistel function) which applies a series of permutations and substitutions.</li>
    <li>Splits the plaintext into two halves and processes them through multiple rounds of processing.</li>
    <li>One half of the data is modified using the round function and the result is XORed with the other half.</li>
</ul>
</td>
<td>
Feistel Structure:
<ul>
    <li>Applies DES encryption three times with different keys.</li>
    <li>Improves security over DES but at the cost of slower performance.</li>
</ul>
</td>
<td>
Substitution-Permutation Network (SPN):
<ul>
    <li>Involves several rounds of substitution (using S-boxes) and permutation.</li>
    <li>Each round involves the mixing of the plaintext bits and the key bits through a series of well-defined steps.</li>
    <li>Ensures diffusion and confusion properties to maximize security.</li>
</ul>
</td>
<td>
Feistel Structure:
<ul>
    <li>Similar to DES but with different round function and key schedule.</li>
    <li>Variable key length allows for flexible security levels.</li>
</ul>
</td>
</tr>
<tr>
<td>Example of Attack</td>
<td>
DES:
<ul>
    <li>With a 56-bit key, there are 2<sup>56</sup> possible keys.</li>
    <li>Modern supercomputers can perform about 10<sup>15</sup> attempts per second.</li>
    <li>This means a DES key can be cracked in about 2<sup>56</sup> / 10<sup>15</sup> ≈ 7 hours.</li>
</ul>
</td>
<td>
3DES:
<ul>
    <li>With a 168-bit key (3 × 56-bit keys), there are 2<sup>168</sup> possible keys.</li>
    <li>Modern supercomputers can perform about 10<sup>15</sup> attempts per second.</li>
    <li>This means cracking a 3DES key would take about 2<sup>168</sup> / 10<sup>15</sup> ≈ 10<sup>37</sup> years.</li>
</ul>
</td>
<td>
AES:
<ul>
    <li>With a 128-bit key, there are 2<sup>128</sup> possible keys.</li>
    <li>Modern supercomputers can perform about 10<sup>15</sup> attempts per second.</li>
    <li>This means cracking an AES-128 key would take about 2<sup>128</sup> / 10<sup>15</sup> ≈ 10<sup>19</sup> years.</li>
</ul>
</td>
<td>
Blowfish:
<ul>
    <li>With a 448-bit key, there are 2<sup>448</sup> possible keys.</li>
    <li>Modern supercomputers can perform about 10<sup>15</sup> attempts per second.</li>
    <li>This means cracking a Blowfish key would take about 2<sup>448</sup> / 10<sup>15</sup> ≈ 10<sup>77</sup> years.</li>
</ul>
</td>
</tr>
<tr>
<td>Developed</td>
<td>IBM, adopted by NIST (1977)</td>
<td>IBM, adopted by NIST (1999)</td>
<td>Vincent Rijmen and Joan Daemen, adopted by NIST (2001)</td>
<td>Bruce Schneier (1993)</td>
</tr>
</tbody>
</table>

</body>
</html>
