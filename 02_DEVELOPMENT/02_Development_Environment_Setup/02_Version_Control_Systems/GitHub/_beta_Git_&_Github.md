<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Git & Codeberg Tutorial</title>
<style>
  /* Generic style */
  body {
       font-family: Arial, sans-serif;
       line-height: 1.6;
       margin: 5em;
       max-width: 1000px; /* Limit screen maximum width */
       margin-left: auto;
       margin-right: auto;
  }
   h1, h2, h3, h4, h5, h6 {
       font-weight: bold;
       margin-bottom: 0.5em;
  }
   h1 {
       font-size: 2.5em;
       line-height: 1.2;
  }
   h2 {
       font-size: 2em;
       line-height: 1.3;
  }
   h3 {
       font-size: 1.8em;
       line-height: 1.4;
  }
   p {
       margin: 1em 0;
       text-align: justify; /* Justify text for better readability */
  }
   a {
       color: #007bff;
       text-decoration: none;
  }
   a:hover {
       text-decoration: underline;
  }
   blockquote {
       margin: 1em 0;
       padding: 0 1em;
       border-left: 3px solid #ccc;
  }
   blockquote cite {
       font-style: italic;
  }
   img {
       max-width: 100%;
       height: auto;
       display: block;
       margin: 1em 0;
  }
   pre {
       background-color: #f8f9fa;
       border: 1px solid #ccc;
       padding: 1em;
       overflow: auto;
       white-space: pre-wrap; /* Wrap long lines in preformatted text */
  }
   code {
       font-family: Consolas, Monaco, 'Andale Mono', monospace;
       font-size: 0.9em;
  }
  /* Tables */
   table {
       width: 100%;
       border-collapse: collapse;
       margin-bottom: 1em;
  }
   th, td {
       border: 1px solid #ccc;
       padding: 0.8em;
  }
   th {
       background-color: #f2f2f2;
  }
  /* Lists */
   ul, ol {
       margin: 1em 0;
       padding-left: 2em;
  }
  /* Miscellaneous */
   sup {
       vertical-align: super;
       font-size: smaller;
  }
   sub {
       vertical-align: sub;
       font-size: smaller;
  }
   @media screen and (max-width: 600px) {
      /* Adjustments for smaller screens */
       body {
           font-size: 16px; /* Font size for better readability */
           line-height: 1.5;
           margin: 0.5em;
      }
       h1 {
           font-size: 2em;
      }
       h2 {
           font-size: 1.8em;
      }
       h3 {
           font-size: 1.6em;
      }
       th, td {
           padding: 0.6em;
      }
       pre {
           padding: 0.5em;
      }
  }
</style>
</head>
<body>

<h2>Git and GitHub Resources</h2>

<ul>
  <li><a href="https://git-scm.com/doc">Git Documentation</a></li>
  <li><a href="https://docs.github.com/en/get-started/start-your-journey/git-and-github-learning-resources">GitHub Learning Resources</a></li>
  <li><a href="https://docs.github.com/en/get-started/learning-about-github/github-glossary">GitHub Glossary</a></li>
</ul>

<p>To install Git on Debian:</p>
<pre><code>$ sudo apt install git</code></pre>

<h3>Tools for Using Git and GitHub</h3>

<ul>
  <li><strong>Command Line Interface (CLI):</strong> Offers direct control over Git operations through the terminal.</li>
  <li><strong>Text Editors (e.g., Vim, NeoVim):</strong> Support Git through plugins for streamlined version control within the editor.</li>
  <li><strong>Integrated Development Environments (IDEs):</strong> IDEs like VSCode and IntelliJ provide built-in Git tools for managing repositories and commits within the development environment.</li>
</ul>

<h3>GitHub Authentication Methods</h3>

<ul>
  <li><strong>Username and Password (with 2FA):</strong> Requires a password and a one-time code via TOTP or SMS. Mandatory for contributors as of March 2023.</li>
  <li><strong>Passkeys:</strong> Passwordless authentication combining security and ease by fulfilling both password and 2FA requirements.</li>
  <li><strong>Personal Access Tokens (PATs):</strong> Token-based authentication for Git operations over HTTPS, offering fine-grained permissions.</li>
  <li><strong>SSH Keys:</strong> Secure, passwordless authentication using a public/private key pair for Git operations.</li>
  <li><strong>SAML SSO:</strong> Used in enterprise environments for single sign-on through an Identity Provider (IdP).</li>
  <li><strong>Credential Managers:</strong> Tools like GitHub CLI and Git Credential Manager (GCM) store credentials securely and simplify login processes.</li>
</ul>

<h3>Authentication by Interaction Method</h3>

<ul>
  <li><strong>Browser Authentication:</strong> Login through the browser using GitHub credentials or SSO via IdP.</li>
  <li><strong>GitHub Desktop Authentication:</strong> Browser-based login supporting 2FA and SSO for secure GitHub Desktop access.</li>
  <li><strong>API Authentication:</strong> Authenticate with the API using fine-grained PATs or OAuth tokens for better permission control.</li>
  <li><strong>Command Line Authentication:</strong> Authenticate via HTTPS with PATs or SSH keys for command line Git operations.</li>
</ul>

<p><strong>Note:</strong> GitHub sessions expire after two weeks of inactivity. Users can switch between multiple accounts without reauthenticating each time.</p>

<p>For more on authentication setup, see the <a href="https://docs.github.com/en/authentication">GitHub Authentication Documentation</a>.</p>

<!-- #################### -->
<hr>

<h3>GitHub Authentication Methods Configuration</h3>

<h4>Using SSH for Secure Authentication</h4>

<a href="https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent">GitHub - Generating a new SSH key and adding it to the ssh-agent</a>

<p>SSH offers stronger authentication and security compared to HTTPS. Follow these steps to set up SSH:</p>

<ol>
  <li>Generate an SSH key pair:</li>
  <pre><code>ssh-keygen -t ed25519 -C "your.email@example.com"</code></pre>
  <p>This command generates a new ed25519 SSH key pair, which is more secure and recommended over older RSA keys. The keys will be saved as <code>~/.ssh/id_ed25519</code> (private key) and <code>~/.ssh/id_ed25519.pub</code> (public key).</p>

  <li>Add your SSH key to the ssh-agent:</li>
  <pre><code>eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519</code></pre>
  <p>The <code>ssh-agent</code> process manages your SSH keys and securely stores your private key in memory. Adding your key to the agent ensures it is available for authentication without repeatedly entering your passphrase.</p>

  <li>Enhance SSH key management with Keychain (Optional):</li>
  <pre><code>$ sudo apt install keychain
$ echo 'eval $(keychain --eval --agents ssh id_ed25519)' >> ~/.bashrc
$ source ~/.bashrc</code></pre>
  <p><strong>Keychain</strong> is a helper program that simplifies SSH key management across sessions. It loads the keys into <code>ssh-agent</code> and persists them across terminal sessions, avoiding the need to re-enter your passphrase after a system reboot or logging in and out.</p>

  <li>Upload the public key to your GitHub account:</li>
  <p>Copy the contents of <code>~/.ssh/id_ed25519.pub</code> and add it to your GitHub account under <em>Settings &gt; SSH and GPG keys</em>.</p>

  <li>Configure Git to use SSH:</li>
  <pre><code>git remote set-url origin git@github.com:user/repo_name.git</code></pre>
</ol>

<ul>
  <li><strong>Security Considerations:</strong></li>
  <ul>
    <li>Be cautious when generating keys directly on disk. Ensure that your environment is secure, and your private key file is accessible only by your user account (e.g., with permissions <code>600</code>).</li>
    <li>The private key (<code>~/.ssh/id_ed25519</code>) should be kept secure and never shared. It is your personal authentication method to the remote server and should be treated with utmost care.</li>
    <li>Consider setting a passphrase for your SSH key. This adds an additional layer of security, ensuring that even if someone gains access to your private key file, they would still need the passphrase to use it.</li>
    <li>Store your SSH private keys securely, possibly using a password manager like <strong>KeePassXC</strong> or <strong>Bitwarden</strong>. This ensures your keys are encrypted and backed up, reducing the risk of loss or unauthorized access.</li>
    <li>Enable Two-Factor Authentication (2FA) on your GitHub account for an added layer of security. This protects your account even if your SSH key is compromised.</li>
    <li>Always use a secure method to backup or transfer your SSH keys. Avoid storing keys on unencrypted disks or transmitting them over unencrypted channels. Ensure that backups are encrypted and securely managed to prevent unauthorized access.</li>
    <li>Regularly back up your SSH keys to a secure location. In case of system failure, you should be able to restore your keys from a trusted backup.</li>
  </ul>
</ul>

<!-- #################### -->
<hr>

<h4>Using GitHub CLI (<code>gh</code>) for HTTPS Authentication</h4>

<a href="https://cli.github.com/">GitHub CLI</a><br>
<a href="https://github.com/cli/cli#installation">GitHub CLI Installation</a>

<p>The GitHub CLI Official (<code>gh</code>) simplifies interaction with GitHub from the command line. It supports HTTPS authentication, allowing you to log in to GitHub and perform various GitHub operations. Follow these steps to set up Git with the GitHub CLI:</p>

<ol>
  <li>Install GitHub CLI:</li>
  <pre><code>sudo apt install gh</code></pre>
  <p>This will install the GitHub CLI on your system.</p>
  <li>Authenticate with GitHub using the CLI:</li>
  <pre><code>gh auth login</code></pre>
  <p>The CLI will guide you through the process of logging in with your GitHub account. You can choose to authenticate via a web browser or by providing a token.</p>
  <li>Configure Git user information:</li>
  <pre><code>git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"</code></pre>
  <p>This configures your Git user information, which is used in commits.</p>
  <li>Verify your authentication status:</li>
  <pre><code>gh auth status</code></pre>
  <p>This command checks if you are authenticated with GitHub and provides details about your authentication status.</p>
</ol>

<ul>
  <li><strong>Security Considerations:</strong></li>
  <ul>
    <li>GitHub CLI securely stores your authentication credentials, making it easier to interact with GitHub without re-entering credentials.</li>
    <li>It's recommended to enable Two-Factor Authentication (2FA) on your GitHub account to add an extra layer of security when using the GitHub CLI.</li>
  </ul>
</ul>

<!-- #################### -->
<hr>

<h4>Using Git Credential Manager (GCM) for HTTPS Authentication</h4>

<a href="https://github.com/GitCredentialManager/git-credential-manager">GitHub - Git Credential Manager</a>

<p>Git Credential Manager (GCM) provides a seamless way to authenticate Git operations over HTTPS. Follow these steps to set up GCM:</p>

<ol>
  <li>Install Git Credential Manager:</li>
  <pre><code>sudo apt-get install git-credential-manager</code></pre>
  <p>This will install GCM, allowing you to manage credentials for Git services like GitHub.</p>

  <li>Configure GCM as your credential helper:</li>
  <pre><code>git config --global credential.helper manager-core</code></pre>
  <p>This command configures Git to use GCM for managing credentials.</p>

  <li>Authenticate with GitHub:</li>
  <p>When you perform your first Git operation that requires authentication, GCM will prompt you to log in to GitHub. Follow the instructions to authenticate using your GitHub account.</p>

  <li>Configure Git user information:</li>
  <pre><code>git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"</code></pre>
  <p>This configures your Git user information, which is used in commits.</p>
</ol>

<ul>
  <li><strong>Security Considerations:</strong></li>
  <ul>
    <li>GCM securely stores your credentials, reducing the need to re-enter them for each Git operation.</li>
    <li>When using GCM, it’s recommended to enable Two-Factor Authentication (2FA) on your GitHub account for added security.</li>
  </ul>
</ul>

<!-- #################### -->
<hr>

<h3>Git Workflow</h3>
<img src="git_workflow.png" alt="Git Workflow" width="830px">

<!-- #################### -->
<hr>

<h3>Git Command Line</h3>
<table>
  <tr>
    <td>
      <p>Clones fork to our local system</p>
      <pre>git clone &lt;fork&gt;</pre>
    </td>
    <td>  
      <p>Make sure local copy is clean and checks status</p>
      <pre>git status</pre>
    </td>
    <td>
      <p>Adds file to staging area</p>
      <pre>git add &lt;file&gt;</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Commits changes (git commit -a -m “commit notes”)</p>
      <pre>git commit -m &lt;comment&gt;</pre>
    </td>
    <td>
      <p>Detailed information about commits</p>
      <pre>git log —-stat</pre>
    </td>
    <td>
      <p>Add origin to local repo</p>
      <pre>git remote add origin https://github.com/repo/git.git</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Pushes main branch to remote git repo and store so you can just (git push)</p>
      <pre>git push -u origin main</pre>
    </td>
    <td>
      <p>Pulls changes from remote repo</p>
      <pre>git pull origin main</pre>
    </td>
    <td>
      <p>Unstage file</p>
      <pre>git reset &lt;file&gt;</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Remove changes before last commit</p>
      <pre>git checkout —- &lt;file&gt;</pre>
    </td>
    <td>
      <p>Create a new branch off your main branch</p>
      <pre>git branch &lt;branch_name&gt;</pre>
    </td>
    <td>
      <p>List current branches</p>
      <pre>git branch</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Switch branches to specified branch name</p>
      <pre>git checkout &lt;branch_name&gt;</pre>
    </td>
    <td>
      <p>Create branch and checkout</p>
      <pre>git checkout -b &lt;branch_name&gt;</pre>
    </td>
    <td>
      <p>Remove all text files</p>
      <pre>git rm ‘*.txt’</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Remove folder from tracking</p>
      <pre>git rm -r &lt;folder_name&gt;</pre>
    </td>
    <td>
      <p>Merge branch into main</p>
      <pre>git merge &lt;branch_name&gt;</pre>
    </td>
    <td>
      <p>Cleanup/remove branch</p>
      <pre>git branch -d &lt;branch_name&gt;</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Push changes to remote repo</p>
      <pre>git push</pre>
    </td>
    <td>
      <p>Delete files that are no longer there while committing</p>
      <pre>git commit -a</pre>
    </td>
    <td>
      <p>Git pull a different directory</p>
      <pre>git -C &lt;repo_location&gt; pull</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Rewriting the remote's history to be exactly like your local copy</p>
      <pre>git push -f origin main</pre>
    </td>
  </tr>
  <tr>
    <td>
      <p>Set the upstream for the main branch</p>
      <pre>git push --set-upstream origin main --force</pre>
    </td>
  </tr>
</table>

<!-- #################### -->
<hr>

<h3>Hard Cases</h3>

<table border="1" cellpadding="10">
  <tr>
    <th>Aspect</th>
    <th>Rebasing Commits</th>
    <th>Force-Pushing to Rewrite Remote</th>
    <th>Squashing Commits</th>
    <th>Amending Commits</th>
    <th>Resetting vs. Reverting</th>
  </tr>
  <tr>
    <td><strong>Purpose</strong></td>
    <td>Integrate changes from one branch into another while maintaining a linear history. Clean up commit history before merging.</td>
    <td>Overwrite the current state of the remote repository with your local changes, including changes in commit history.</td>
    <td>Combine multiple commits into a single commit to create a cleaner, more readable history.</td>
    <td>Edit the most recent commit to correct a mistake (message, files, etc.) without creating a new commit.</td>
    <td>Undo changes in a controlled manner. Reset alters the history; revert creates a new commit to reverse changes.</td>
  </tr>
  <tr>
    <td><strong>Operation</strong></td>
    <td>Replays your commits on top of another branch, creating new commit hashes. Changes the base of your branch to make the history linear.</td>
    <td>Forcibly updates the remote branch to match your local branch, regardless of the current state of the remote branch. This includes the rewritten commit history.</td>
    <td>Squashes selected commits into a single commit during an interactive rebase.</td>
    <td>Modifies the last commit by changing the commit message, adding or removing files, or updating the content of staged files.</td>
    <td>Reset moves the HEAD and possibly the index or working directory to a previous commit; revert creates a new commit that undoes the changes.</td>
  </tr>
  <tr>
    <td><strong>Impact on History</strong></td>
    <td>Rewrites the commit history of your branch by changing parent commits, resulting in a linear, cleaner history.</td>
    <td>Rewrites the history of the remote branch, which can cause conflicts for others if they have pulled the branch before the force-push.</td>
    <td>Combines multiple commits into one, which alters the commit history by removing intermediate commits.</td>
    <td>Rewrites the last commit, altering the commit history. It is safe if the commit hasn’t been pushed, but risky if shared.</td>
    <td>Reset changes the history by moving HEAD; revert preserves history by adding a new commit that undoes the changes.</td>
  </tr>
  <tr>
    <td><strong>Collaboration Risks</strong></td>
    <td>Can cause issues if others have based work on your branch before you rebase. May result in conflicts or diverging history.</td>
    <td>High risk if others have already pulled the branch. Can disrupt the work of collaborators by altering shared history.</td>
    <td>Risky if others have based their work on the commits being squashed, as it changes the commit history.</td>
    <td>Risks arise if the commit has already been shared; collaborators may need to rebase or reset their work.</td>
    <td>Reset can be destructive and lead to loss of changes; revert is safer but may lead to confusing commit history.</td>
  </tr>
  <tr>
    <td><strong>Use Cases</strong></td>
    <td>Typically used to clean up a branch’s history before merging into a main branch. Best used when you haven’t shared the branch yet.</td>
    <td>Used after rebasing to update the remote branch or when correcting mistakes in a branch that has already been pushed. Should be used with caution.</td>
    <td>Used to create a cleaner, more understandable history by combining minor commits into a single, significant commit.</td>
    <td>Used to correct the last commit’s message or contents before pushing. Useful for minor changes and avoiding unnecessary commits.</td>
    <td>Use reset for local, private changes and revert for public changes. Reset is for when you want to erase history; revert is for undoing changes in a safe, non-destructive way.</td>
  </tr>
  <tr>
    <td><strong>Commands</strong></td>
    <td><pre>git rebase main</pre></td>
    <td><pre>git push -f origin feature-branch</pre></td>
    <td><pre>git rebase -i HEAD~n</pre></td>
    <td><pre>git commit --amend</pre></td>
    <td><pre>git reset [--soft | --mixed | --hard] <br>git revert <commit></pre></td>
  </tr>
</table>

<!-- #################### -->
<hr>

<h3>Rebase Local Git Repository from Upstream</h3>

<p>If your forked repository has diverged significantly from the upstream repository, you can rebase your local repository to synchronize with the upstream changes:</p>
<ol>
  <li>Check if the upstream repository is configured:</li>
  <pre>git remote -v</pre>
  <p>If not configured, add upstream:</p>
  <pre>git remote add upstream &lt;upstream-repo-url&gt;</pre>
  <li>Switch to your main branch and fetch from upstream:</li>
  <pre>
git checkout main
git fetch upstream
  </pre>
  <li>Rebase your main branch onto the upstream main branch:</li>
  <pre>git rebase upstream/main</pre>
  <li>Decide how to apply your changes:</li>
  <ul>
    <li>If you want to merge your remote main branch changes:</li>
    <pre>git pull origin main</pre>
    <li>If you want to overwrite your remote main branch changes with the rebased changes:</li>
    <pre>git push -u origin main --force</pre>
  </ul>
</ol>
<p>Your local and remote main branches are now synced with the upstream repository.</p>

<!-- #################### -->
<hr>

<h3>Using Codeberg for Open Source Contribution</h3>

<p><a href="https://codeberg.org/">Codeberg</a> is a free and open-source collaborative platform similar to GitHub. Here's how you can contribute to projects on Codeberg:</p>
<ol>
  <li><strong>Forking a Repository:</strong> Click on the "Fork" button on the repository's page to create a copy under your Codeberg account.</li>
  <li><strong>Cloning the Forked Repository:</strong> Clone your forked repository to your local machine:</li>
  <pre>git clone https://codeberg.org/yourusername/repository.git</pre>
  <li><strong>Making Changes:</strong> Make changes to the codebase locally using your preferred editor.</li>
  <li><strong>Committing Changes:</strong> Stage and commit your changes:</li>
  <pre>
git add .
git commit -m "Your commit message"
  </pre>
  <li><strong>Pushing Changes:</strong> Push your changes to your Codeberg repository:</li>
  <pre>git push origin main</pre>
  <li><strong>Creating a Pull Request:</strong> Go to the original repository on Codeberg, and click on "New Pull Request". Compare across forks, select your forked repository and create the pull request.</li>
</ol>

<!-- #################### -->
<hr>

<h3>Git - Setting Up Ignore File</h3>
<p>To ignore certain files across all your Git repositories, you can set up a global gitignore file:</p>
<h4>Ignore all .DS_store files:</h4>
<p>Create a global git ignore file:</p>
<pre>echo .DS_Store &gt;&gt; ~/.gitignore_global</pre>
<p>Set the global git ignore file:</p>
<pre>git config --global core.excludesfile ~/.gitignore_global</pre>

</body>
</html>
