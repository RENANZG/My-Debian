# References
# https://github.com/simplex-chat/simplex-chat/blob/stable/docs/CLI.md

{% if grains['id'] == 'dom0' %}

install-debian-12-minimum:
  cmd.run:
    - name: qvm-template install debian-12-minimum
    - unless: qvm-ls | grep -q debian-12-minimum

vms-depends:
  qvm.template_installed:
    - name: debian-12-minimum

clone-simplex-template:
  qvm.clone:
    - name: simplex-template
    - source: debian-12-minimum

simplex-appvm-present:
  qvm.present:
    - name: simplex
    - template: simplex-template
    - label: blue
    - class: AppVM

simplex-appvm-prefs:
  qvm.prefs:
    - name: simplex
    - netvm: sys-whonix

{% elif grains['id'] == 'tpl-simplex' %}

install-simplex-chat:
  cmd.run:
    - name: |
        curl -fsSL https://raw.githubusercontent.com/simplex-chat/simplex-chat/stable/install.sh | bash
    - cwd: /home/user
    - user: user
    - unless: test -x /usr/local/bin/simplex-chat

verify-simplex-install:
  cmd.run:
    - name: simplex-chat --version
    - user: user

{% elif grains['id'] == 'simplex' %}

setup-simplex-data-dir:
  file.directory:
    - name: /home/user/.simplex
    - user: user
    - group: user
    - mode: 0750

start-simplex-chat:
  cmd.run:
    - name: simplex-chat
    - cwd: /home/user
    - user: user
    - bg: true

{% endif %}
