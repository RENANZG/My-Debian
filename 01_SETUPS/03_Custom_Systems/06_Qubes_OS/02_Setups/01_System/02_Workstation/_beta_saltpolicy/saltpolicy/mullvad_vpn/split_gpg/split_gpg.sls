# vim:ft=sls
# SaltStack policy for setting up Split GPG in Qubes OS
# Applying the Policy
# sudo salt-call state.apply split_gpg

install_qubes_gpg_proxy:
  pkg.installed:
    - name: qubes-gpg-split
    - refresh: true

enable_gpg_in_vault:
  cmd.run:
    - name: |
        qvm-service --enable vault qubes.Gpg
    - unless: qvm-check --service vault qubes.Gpg

configure_gpg_clients:
  cmd.run:
    - name: |
        echo "export QUBES_GPG_DOMAIN=vault" >> /rw/config/rc.local
    - require:
      - pkg: install_qubes_gpg_proxy

setup_gpg_socket:
  file.managed:
    - name: /etc/qubes-rpc/policy/qubes.Gpg
    - source: salt://split_gpg/qubes.Gpg
    - user: root
    - group: root
    - mode: 0644

reload_rpc_policy:
  cmd.run:
    - name: systemctl restart qubes-qrexec-agent
    - require:
      - file: setup_gpg_socket

# Optional: Import a GPG key into the vault VM
import_gpg_key:
  cmd.script:
    - name: salt://split_gpg/import_gpg_key.sh
    - require:
      - cmd: enable_gpg_in_vault
