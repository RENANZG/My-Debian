---
title: How to architect your Qubes OS with SaltStack
date: 2024-09-20
author: Benjamin Grande
styles:
  author:
    bg: default
    fg: '#43c4f3'
  date:
    bg: default
    fg: '#777'
  headings:
    '1':
      fg: '#3874d8,bold'
    '2':
      fg: '#3874d8,bold'
    '4':
      fg: '#99bfff,bold'
  margin:
    bottom: 0
    left: 5
    right: 5
    top: 0
  padding:
    bottom: 0
    left: 5
    right: 5
    top: 0
  slides:
    bg: default
    fg: '#43c4f3'
  style: monokai
  table:
    column_spacing: 3
  title:
    fg: '#63a0ff,bold,italics'
---

# How to architect your Qubes OS with SaltStack

## Easier than you think

----------------------------------- *Qubes OS Summit 2024*

---------------------------------------- *Benjamin Grande*

---

## Table of Contents

* **What**
* **Why**
  * *backups* aren't always fitting
  * managing *infrastructure with ShellScripts* don't go well
  * use proper IaaC tools such as *Salt*
* **How**
  * to *architect* using best practices
  * to do *basic Salt states*
  * to *customize states*
* **Bad times**
* **Contact**
* **References**
* **QA**

---

## What's my jam

* FOSS maintainer and contributor
* Automates of every task
* Trail hikes
* Table tennis

---

## Disclaimer

* Licenses: AGPL-3.0-or-later (code), CC-BY-SA-4.0 (documentation)
* Pseudo code is used to fit the slides
* Not a complete explanation, just an intro

---

## What

I want to:

* *Harden* Qubes OS defaults
* *Automate* workflows between qubes
* *Replicate* the setup easily on any machine

---

## What Salt is

* **Configuration management system**: establish a state
* **Distributed remote execution system**: execute commands and query data

---

## Salt alternatives

* **Puppet and Chef**: doesn't have native integration in Qubes OS.
* **Ansible**: talk tomorrow by Kushal Das named "Qubes in the land of Ansible"
* **ShellScripts**: way out of the league

---

## Why Qubes

* **Qrexec**:
  * **Framework (RPC)**: Usability, Separation of Duty, Defense in Depth, Minimize Attack Surface
  * **Policy (IAM/ACL)**: Principle of Least Privilege, Secure by Default
* **Philosophy**:
  * **Open Source**: Open by Design
  * **Security**: Keep It Simple Stupid

---

## Qubes brings security to Salt execution

* **Masterless minion**: no connectivity to dom0
* **Disposable management qube**: salt packages and connector

---

## How Salt SSH looks like in traditional systems VS Qubes

* Traditional system:

  ```
   ------  Apply state.sls  --------
  | dom0 |  -------------> | target |
   ------        SSH        --------
  ```

* Qubes:

  ```
   ------  Copy state.sls  ------------------
  | dom0 | -------------> | disp-mgmt-target |
   ------     Qrexec       ------------------
                                | Apply state.sls   --------
                                \----------------> | target |
                                     Qrexec         --------
  ```

---

## Why automate

Infrastructure replication:

* Backups are *time-consuming*
* SaltStack:
  * *High readability*, uses the *Qubes API*, built for *idempotency*
  * Backup *state in code* (IaaC) and only qubes that stores data
* It is *fun!*

---

### Why: Shellscript status quo

What lead to the status quo of *ShellScript?*

* Some *already know* shell so why learn anything else
* Others *think* it is platform independent if they overloads with enough logic
* Some even *think* it will lead to the same result on every machine
* Bust most of all, most *community guides uses* tutorials with ShellScripts

---

### Why: Meet John

<!-- stop -->

```
   --------------------------------------
  / The shell is a reliable tool, works  \
  \ on Unix based systems since the 70s. /
   --------------------------------------
  /                   ---------------------------------
 O  ->->->  +----+    | I trust you, I hope you trust |
/|\         | PC | -- | yourself to not have made     |
 |  <<<<<<  +----+    | quoting mistakes.             |
/ \                   --------------------------------
```

<!-- stop -->

```
    \ ----------------------------------
     / Why my computer doesn't love me? \
     \ Qubes borked, pls help now!!!!!! /
      ----------------------------------
```

---


### Why: Meet Alice

She's been through that before and wants to help him pass through the grief.

<!-- stop -->

1. **Denial**: Salt has bugs also, Jinja bad, Shell gud
2. **Anger**: NOOO WAY, ShellScripts rule
3. **Bargaining**: I'll use the Python API but won't touch Salt
4. **Depression**: It ain't that simple, I guess Qubes OS isn't for me
5. **Acceptance**: Well, YAML+Jinja is way easier and cleaner than I expected

---

### Why: Alice lists Salt features

* **Declarativeness**: describe what you want, let the program handle the rest
* **Readability**: YAML + Jinja (when necessary)
* **Idempotence**: consistent results focused on achieving a state
* **Imports**: easy to include from other formulas and build upon it
* **Targeting**: roles, regex, grains (properties queried only after boot)

<!-- stop -->

John thinks those are only fancy words.

---

### Why: Salt VS Shell: Task: Target

Alice sets a task to do in Salt and asks John to do it using ShellScripts:

* Install Thunar and GDK Pixbuf
* Work on Debian and Fedora based distributions
* Install only necessary packages

---

#### Why: Salt VS Shell: John: qvm-run argument

```sh
qvm-run --user root QUBE -- '
set -eu
distro="$(awk -F= "/^ID=/{print \$2}" /etc/os-release | tr -d \")"
for d in ${distro}; do
  case "${d}" in
    debian) apt update && DEBIAN_FRONTEND=noninteractive apt install --force-confdef --force-confold --no-install-recommends thunar libgdk-pixbuf2.0-bin;;
    fedora) dnf --setopt=install_weak_deps=False install --assumeyes Thunar gdk-pixbuf2;;
    *) exit;;
  esac
done'
```

---

#### Why: Salt VS Shell: Alice: Targeting with Salt

```salt
{% set pkg = {
  'Debian': {
    'pkg': ['thunar', 'libgdk-pixbuf2.0-bin'],
  },
  'RedHat': {
    'pkg': ['Thunar', 'gdk-pixbuf2'],
  },
}.get(grains.os_family) -%}

thunar-installed-os-specific:
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}
```

---

### Why: Salt VS Shell: Task: Qube creation

John angrily shouts for another round, therefore a new task it set.

* Create a template for DispVMs with the following properties:
  * **Template**: `debian-12-xfce`
  * **Name**: `dvm-browser`
  * **Label**: `red`
  * **Template for DispVMs**: `True`

---

#### Why: Salt VS Shell: John: Qube creation with Shell

```sh
set -eu
qvm-template install debian-12-xfce
if ! qvm-check -- dvm-browser >/dev/null; then
  qvm-create -t debian-12-xfce -l red dvm-browser
fi
if "$(qvm-prefs dvm-browser template)" != "debian-12-xfce"; then
  qvm-prefs dvm-browser template debian-12-xfce
fi
if "$(qvm-prefs dvm-browser label)" != "red"; then
  qvm-prefs dvm-browser label red
fi
if "$(qvm-prefs dvm-browser template_for_dispvms)" != "True"; then
  qvm-prefs dvm-browser template_for_dispvms True
fi
```

---

#### Why: Salt VS Shell: Alice: Qube creation with Salt

```salt
alice-installed-debian-12-xfce:
  qvm.template_installed:
    - name: debian-12-xfce
alice-created-dvm-browser:
  qvm.vm:
    - require:
      - qvm: alice-installed-debian-12-xfce
    - name: dvm-browser
    - present:
      - template: debian-12-xfce
      - label: red
    - prefs:
      - template: debian-12-xfce
      - label: red
      - template_for_dispvms: True
```

---

## Boring, I am already convinced, show goodies

<!-- stop -->

The "goodies" depends on what you want to accomplish.

---

## How

1. *Design* the architecture
1. *Set rules* for consistency, readability, reusability
1. *Try* it out

---

### How: Architectural steps

1. *Study* Salt, Qubes OS, target OS, service manager
1. *Think* how tasks can be divided into multiple qubes
1. *Sketch* or *write free-form text* on how tasks can be divided into qubes
1. *Document* design choices
1. *Declare* the state in and apply it in test mode
1. *Apply* state

> Note the design is independent of the management software

---

### How: Qube types use cases

*Software installation*:

* **TemplateVM**: descendants qubes can have updates and be offline
* **StandaloneVM**: when binding directories is troublesome

*User interaction*:

* **DispVM**: data processing
* **AppVM**: data storage

*Admin*:

* **AdminVM**: Qrexec policy *isn't restrictive enough*

---

### How: Consistency

Why?

<!-- stop -->

*Consistent names*:

* **Documentation**
* **State declaration**
* **File hierarchy**
* **File names**
* **Qube properties**

*Reviews*:

* **Macros and includes**
* **CI/CD**

---

### How: Salt Modules

* *State modules*:

  **/srv/salt/example.sls**:

  ```yaml
  installed-gentoo-minimal:
    qvm.template_installed:
      - name: gentoo-minimal
      - fromrepo: qubes-templates-community-testing
  ```

* *Execution modules*:

  ```sh
  qubesctl state.apply example
  ```

---

### How: Alice has problems

**Alice** is a freelance developer whom works with *multiple clients* daily, labor tracked in *Git*.

She already uses *different coding qubes per client and per environment*: **clientB-code**, **clientB-build-test**.

*Copying* code from the former to the latter can take *a long time*.

---

### How: Alice creates a solution

Alice designs a Qrexec service named `alice.GitFetch`:

```
                          Pull allowed
                          >>>>>>>>>>>>>>
 --------------------    /              \    --------------
| clientB-build-test |--> alice.GitFetch -->| clientB-code |
 --------------------    \                   --------------
                          XXXXX
                          Push blocked
```

---

### How: Alice's Qrexec service

**/srv/salt/alice/files/git-client/git-remote-qrexec**:

```text
Read authority and path from qrexec://<authority>/<path>
Communicate using the git-remote-helper protocol
```

**/srv/salt/alice/files/git-server/alice.GitFetch**:

```text
Read name from env variable QREXEC_SERVICE_ARGUMENT
Run git-upload-pack -- repository
```

**/srv/salt/alice/files/admin/git-qrexec.policy**:

```qrexecpolicy
alice.GitFetch +repoB clientB-build-test clientB-code allow
alice.GitFetch *      clientB-build-test @anyvm deny
```

---

### How: Alice's shared state

**/srv/salt/alice/git-install.sls**:

```salt
alice-git-installed:
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - git
```

---

### How: Alice's client states

**/srv/salt/alice/git-client.sls**:

```salt
include:
  - alice.git-install

{% set git = {
  'Debian': {
    'exec_path': '/usr/lib/git-core',
  },
  'RedHat': {
    'exec_path': '/usr/libexec/git-core',
  },
}.get(grains.os_family) -%}

alice-git-remote-helper:
  file.managed:
    - require:
      - sls: alice.git-install
    - source: salt://alice/files/git-client/git-remote-qrexec
    - name: {{ git.exec_path }}
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
```

---

### How: Alice's server state

**/srv/salt/alice/git-server.sls**:

```salt
include:
  - alice.git-install

alice-git-rpc:
  file.managed:
    - require:
      - sls: alice.git-install
    - source: salt://alice/files/git-server/alice.GitFetch
    - name: /etc/qubes-rpc/alice.GitFetch
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
```

---

### How: Alice's admin state

**/srv/salt/alice/git-policy.sls**:

```salt
alice-git-rpc:
  file.managed:
    - source: salt://alice/files/admin/git-qrexec.policy
    - name: /etc/qubes/policy.d/40-git.policy
    - mode: '0664'
    - user: root
    - group: qubes
    - makedirs: True
```

---

### How: Alice applies the states

Alice applies the policy to Dom0 and the remaining states to all templates:

```sh
qubesctl state.apply alice.git-policy
```

```sh
qubesctl --skip-dom0 --templates \
         state.apply alice.git-client,alice.git-server
```

---

### How: Alice's defines a highstate

**/srv/salt/alice/init.top**:

```salt
base:
  'dom0':
    - match: nodegroup
    - alice.git-policy
  'I@qubes:type:template and (G@os_family:Debian or G@os_family:RedHat)':
    - match: compound
    - alice.git-client
    - alice.git-server
```

```sh
qubesctl top.enable alice
qubesctl --all state.apply
```

---

### How: Alice wants more customization

Alice ends up producing **many more formulas**. After a while, she notices that their formulas have **hardcoded template versions spread across multiple states**.

```salt
alice-installed-fedora-39:
  qvm.template_installed:
    - name: fedora-39
```

<!-- stop -->

```salt
alice-installed-fedora-40:
  qvm.template_installed:
    - name: fedora-40
```

<!-- stop -->

`Pillars` with Jinja to the rescue.

---

### How: Alice sets the pillars

**/srv/pillar/alice/init.sls**:

```salt
alice:
  template:
    fedora:
      - version: 40
    debian:
      - version: 12
```

**/srv/pillar/alice/init.top**:

```salt
base:
  'dom0':
    - match: nodegroup
    - alice
```

---

### How: Alice declares the Fedora installation

**/srv/salt/alice/template.jinja**:

```salt
{% set fedora_version = salt['pillar.get']('alice:template:fedora:version', '40') %}
{% set fedora_repo = salt['pillar.get']('alice:template:fedora:fromrepo'), 'qubes-templates-itl' %}
```

**/srv/salt/alice/install-fedora.sls**:

```salt
{%- import "alice/template.jinja" as template -%}
alice-installed-fedora-{{ template.fedora_version }}:
  qvm.template_installed:
    - name: fedora-{{ template.fedora_version }}
    - fromrepo: {{ template.fedora_repo }}
```

---

### How: Alice's state **/srv/salt/alice/create-example.sls**

```salt
{% import "alice/template.jinja" as template %}
include:
  - alice.install-fedora

alice-created-example:
  qvm.vm:
    - require:
      - sls: alice.install-fedora
    - name: example
    - present:
      - label: red
      - template: fedora-{{ template.fedora_version }}
    - prefs:
      - label: red
      - template: fedora-{{ template.fedora_version }}
```

---

### How: Alice applies states with pillars

Ensure Alice's *pillar* is in the *highstate*:

```sh
qubesctl top.enable alice pillar=True
```

Ensure the desired qubes are created and properties *enforced*:

```
qubesctl state.apply alice.create-example
```

---

## Ain't all sunshine and rainbows

* **OS support**: Fedora updating Python *often breaks* Salt (RedHat Inc collaborates on Fedora and Ansible)
* **Troubleshooting**: syntax errors exceptions can be *hard to understand*
* **Real-time output**: managed qubes *don't return output to the management* *qube until the run has completed* (Ansible has)

---

## Summary

* **ShellScripts** are *strongly discouraged*
* **Don't bargain with your infra**, use well tested tools
* **Design and document** the *architecture before coding*
* **Be consistent** throughout your *designs*
* **Apply best practices** on every step

---

## I did something

Qusal: Salt formulas for Qubes OS

---

## Contact

* Benjamin Grande M. S.
* Email: <ben.grande.b@gmail.com>
* Github: <https://github.com/ben-grande>
* Codeberg: <https:///codeberg.org/ben.grande.b>
* PGP code key: DF38 3487 5B65 7587 13D9 2E91 A475 969D E4E3 71E3
* PGP e-mail key: CCDD 547A 4AD5 E5A2 EA6F 0934 96A5 15DC 1EB9 622F

---

## References

* Qubes RPC: <https://www.qubes-os.org/doc/qrexec/>
* Qubes Salt guide: <https://www.qubes-os.org/doc/salt/>
* Qubes organization guide: <https://www.qubes-os.org/news/2022/10/28/how-to-organize-your-qubes/>
* Salt State modules: <https://docs.saltproject.io/en/latest/ref/states/all>
* Salt Execution modules: <https://docs.saltproject.io/en/latest/ref/modules/all>
* Salt Top file: <https://www.qubes-os.org/doc/qrexec/>
* Shaker: <https://github.com/unman/shaker>
* Qusal: <https://github.com/ben-grande/qusal>

---

## Thoughts

```text
 .--------------.   .--------------.   .--------------.
| .------------. | | .------------. | | .------------. |
| |   ______   | | | |   ______   | | | |   ______   | |
| |  / _ __ `. | | | |  / _ __ `. | | | |  / _ __ `. | |
| | |_/ ___) | | | | | |_/ ___) | | | | | |_/ ___) | | |
| |    / ___.' | | | |    / ___.' | | | |    / ___.' | |
| |    |_|     | | | |    |_|     | | | |    |_|     | |
| |    (_)     | | | |    (_)     | | | |    (_)     | |
| |            | | | |            | | | |            | |
| '------------' | | '------------' | | '------------' |
 '--------------'   '--------------'   '--------------'
```
