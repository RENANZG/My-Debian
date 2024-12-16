<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SaltStack Automation in Qubes OS</title>
<style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      margin: 20px;
      padding: 20px;
      background-color: #f9f9f9;
      color: #333;
    }
    h1, h3 {
      color: #2c3e50;
    }
    code {
      background-color: #eaeaea;
      padding: 2px 4px;
      border-radius: 4px;
    }
    pre {
      background-color: #f4f4f4;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      overflow-x: auto;
    }
    ul {
      margin-left: 20px;
    }
</style>
</head>
<body>

  <h2>SaltStack Automation in Qubes OS</h2>

  <h3>Overview</h3>

  <p>SaltStack is a powerful automation tool integrated into Qubes OS for managing system configurations and updates.</p>

  <h3>Base Salt Configuration</h3>

  <p>The base Salt configuration directory in dom0 is:</p>

  <pre><code>/srv/salt/qubes/README.rst</code></pre>

  <p>To initialize the user Salt configuration directories, run the following command in dom0:</p>

  <pre><code>sudo qubesctl state.sls qubes.user-dirs</code></pre>

  <p>This command creates the following directories:</p>

  <ul>
    <li><code>/srv/user_salt/</code>: Stores user-defined Salt states.</li>
    <li><code>/srv/user_formulas/</code>: Stores custom Salt formulas.</li>
    <li><code>/srv/user_pillar/</code>: Stores pillar data for configurations.</li>
  </ul>

  <p>Additionally, a top file is generated at:</p>

  <pre><code>/srv/user_salt/top.sls</code></pre>

  <h3>Example: Adding a Custom Policy</h3>

  <p>To create a new policy, follow these steps:</p>
  <ol>
    <li>Create a directory for your policy, for example:</li>
    <pre><code>mkdir -p /srv/user_salt/my_policy</code></pre>
    <li>Create a new Salt state file, e.g., <code>install_tools.sls</code>:</li>
    <pre><code>
# /srv/user_salt/my_policy/install_tools.sls
install-tools:
  pkg.installed:
    - pkgs:
      - git
      - curl
      - vim
    </code></pre>
    <li>Add the new policy to the <code>top.sls</code> file:</li>
    <pre><code>
# /srv/user_salt/top.sls
base:
  '*':
    - my_policy.install_tools
    </code></pre>
    <li>Apply the policy:</li>
    <pre><code>sudo qubesctl state.apply</code></pre>
  </ol>

  <h3>Practical Tips</h3>

  <ul>
    <li>Test new policies in a disposable VM before applying them globally.</li>
    <li>Use descriptive names for your state files and directories.</li>
    <li>Leverage the power of pillars for secure and reusable configurations.</li>
    <li>Use version control (e.g., Git) to manage your Salt states and track changes.</li>
  </ul>

  <h3>References</h3>

  <ul>
    <li><a href="https://www.qubes-os.org/doc/salt/" target="_blank">Qubes OS SaltStack Documentation</a></li>
    <li><a href="https://docs.saltproject.io/" target="_blank">SaltStack Official Documentation</a></li>
    <li><a href="https://forum.qubes-os.org/t/qubes-salt-beginners-guide/20126/40" target="_blank">Qubes Salt Beginner’s Guide - Qubes Community Guides</a></li>
  </ul>

</body>
</html>
