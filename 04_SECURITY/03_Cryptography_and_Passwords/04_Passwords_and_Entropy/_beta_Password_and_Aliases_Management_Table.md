<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Password and Aliases Management Table</title>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    h1, h2 {
      color: #333;
      text-align: center;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 40px;
    }
    th, td {
      border: 1px solid black;
      padding: 12px;
      text-align: left;
    }
    th {
      background-color: #f2f2f2;
      font-weight: bold;
    }
    .critical {
      background-color: #bd2727;
    }
    .high {
      background-color: #e79e27;
    }
    .moderate {
      background-color: #e7e532;
    }
    .low {
      background-color: #5ad840;
    }
</style>
</head>
<body>

<h1>Password and Aliases Management Table</h1>

<table >
  <tr>
    <th>Importance</th>
    <th>Password Category</th>
    <th>User or Email Aliases</th>
    <th>Examples of Diceware Passwords</th>
  </tr>
  <!-- Critical Section -->
  <tr class="critical">
    <td rowspan="9">Critical</td>
    <td>Critical Passwords Manager Database</td>
    <td>N/A</td>
    <td>cloud, sea, star, shadow, dragon, sea</td>
  </tr>
  <tr class="critical">
    <td>Nuke Password</td>
    <td>N/A</td>
    <td>fast, shadow, moon, sun, star, sea</td>
  </tr>
  <tr class="critical">
    <td>Multi-Factor Authentication Database</td>
    <td>N/A</td>
    <td>boat, moon, fast, sun, star, sea</td>
  </tr>
  <tr class="critical">
    <td>Full-Disk Encryption</td>
    <td>N/A</td>
    <td>moon, dragon, sea, shadow, campfire, forest</td>
  </tr>
  <tr class="critical">
    <td>Encrypted Hidden Volume or Operating System</td>
    <td>N/A</td>
    <td>boat, moon, fast, sun, star, sea</td>
  </tr>
  <tr class="critical">
    <td>Root Password</td>
    <td>host</td>
    <td>light, star, moon, fire, sea, tree</td>
  </tr>
  <tr class="critical">
    <td>Critical Backup Encryption</td>
    <td>N/A</td>
    <td>lake, sun, wind, forest, dragon, river</td>
  </tr>
  <tr class="critical">
    <td>Financial Password</td>
    <td>financial-acc2@yourdomain.com</td>
    <td>cloud, river, storm, bird, sun, sky</td>
  </tr>
  <tr class="critical">
    <td>Server SSH Key Password</td>
    <td>ssh-server9642@yourdomain.com</td>
    <td>shadow, lake, storm, wind, sea, tree</td>
  </tr>
  <!-- High Security Section -->
  <tr class="high">
    <td rowspan="5">High</td>
    <td>High Passwords Database</td>
    <td>N/A</td>
    <td>cloud, sea, star, shadow, fire, bird</td>
  </tr>
  <tr class="high">
    <td>Work Email Password</td>
    <td>work-email9452@yourdomain.com</td>
    <td>fire, shadow, dragon, cloud</td>
  </tr>
  <tr class="high">
    <td>Personal Email Password</td>
    <td>personal-email6374@yourdomain.com</td>
    <td>star, flower, sea, shadow, fire, bird</td>
  </tr>
  <tr class="high">
    <td>Personal SSH Key Password</td>
    <td>ssh-personal1428@yourdomain.com</td>
    <td>bird, cloud, tree, sun, fire, sea</td>
  </tr>
  <tr class="high">
    <td>VPN Account Password</td>
    <td>vpn9273@yourdomain.com</td>
    <td>sea, light, star, shadow</td>
  </tr>
  <!-- Moderate Section -->
  <tr class="moderate">
    <td rowspan="3">Moderate</td>
    <td>Moderate Passwords Database</td>
    <td>N/A</td>
    <td>ocean, flower, cloud, sea, star, shadow</td>
  </tr>
  <tr class="moderate">
    <td>User Account Password</td>
    <td>user</td>
    <td>cat, shadow, sky, ocean, flower, light</td>
  </tr>
  <tr class="moderate">
    <td>Email Password (Moderate Accounts)</td>
    <td>moderate-gd7389@yourdomain.com</td>
    <td>light, lake, shadow, sea</td>
  </tr>
  <!-- Low Section -->
  <tr class="low">
    <td rowspan="4">Low</td>
    <td>Low Passwords Database</td>
    <td>N/A</td>
    <td>cloud, sea, star, shadow</td>
  </tr>
  <tr class="low">
    <td>Disposable Social Media Password</td>
    <td>social2864@yourdomain.com</td>
    <td>bird, sun, sea, fire</td>
  </tr>
  <tr class="low">
    <td>Temporary Email Password</td>
    <td>temp-email4872@yourdomain.com</td>
    <td>cloud, moon, star, light</td>
  </tr>
  <tr class="low">
    <td>Miscellaneous Accounts Password</td>
    <td>misc1234@yourdomain.com</td>
    <td>bird, tree, cloud, forest</td>
  </tr>
</table>

<p>*Use 2FA whenever possible for sensitive activities.</p>
<p>*Consider using deniable encryption in contexts where the ability to deny possession of information is critical.</p>

</body>
</html>
