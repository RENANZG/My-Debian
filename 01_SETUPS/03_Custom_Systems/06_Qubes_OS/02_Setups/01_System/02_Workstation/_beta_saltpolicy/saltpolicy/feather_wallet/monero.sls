# vim:ft=sls
# SaltStack policy for Monero Wallet in Qubes OS
#

# Variables for template and VMs
monero_template: whonix-ws-14-monero
monero_daemon_vm: monerod-ws
monero_wallet_vm: monero-wallet-ws
network_vm: sys-whonix

# 1. Create TemplateVM
create_template:
  qvm.clone:
    - source: whonix-ws-14
    - name: {{ monero_template }}

# 2. Create Daemon's AppVM
create_daemon_vm:
  qvm.present:
    - name: {{ monero_daemon_vm }}
    - template: {{ monero_template }}
    - label: green
    - netvm: {{ network_vm }}

extend_daemon_volume:
  cmd.run:
    - name: |
        qvm-volume extend {{ monero_daemon_vm }}:private 70G
    - unless: |
        qvm-volume info {{ monero_daemon_vm }}:private | grep 'size.*70G'

enable_monerod_service:
  cmd.run:
    - name: qvm-service --enable {{ monero_daemon_vm }} monerod-mainnet

# 3. Create Wallet's AppVM
create_wallet_vm:
  qvm.present:
    - name: {{ monero_wallet_vm }}
    - template: {{ monero_template }}
    - label: green
    - netvm: ""

# 4. Create qrexec Policy
create_qrexec_policy:
  file.managed:
    - name: /etc/qubes-rpc/policy/whonix.monerod-mainnet
    - contents: |
        {{ monero_wallet_vm }} {{ monero_daemon_vm }} allow
    - user: root
    - group: root
    - mode: 0644

# 5. Set Up TemplateVM
create_system_user:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_template }} \
          "sudo useradd --create-home --system --user-group monerod"
    - unless: qvm-run --pass-io {{ monero_template }} "id -u monerod"

create_systemd_unit:
  cmd.run:
    - name: |
        echo '[Unit]\nDescription=Monero Full Node Mainnet\nConditionPathExists=/var/run/qubes-service/monerod-mainnet\nAfter=qubes-sysinit.service\n\n[Service]\nUser=monerod\nGroup=monerod\nType=forking\nPIDFile=/home/monerod/.bitmonero/monerod.pid\nExecStart=/usr/local/bin/monerod --detach --no-igd --p2p-bind-ip=127.0.0.1 --pidfile=/home/monerod/.bitmonero/monerod.pid\nRestart=always\n\n[Install]\nWantedBy=multi-user.target' \
        | qvm-run --pass-io {{ monero_template }} "sudo tee /lib/systemd/system/monerod-mainnet.service"

fix_permissions:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_template }} "sudo chmod 0644 /lib/systemd/system/monerod-mainnet.service"

enable_systemd_unit:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_template }} "sudo systemctl enable monerod-mainnet.service"

shutdown_template:
  cmd.run:
    - name: |
        qvm-shutdown --wait {{ monero_template }}

# 6. Set Up Daemon VM
install_monerod:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_daemon_vm }} \
          "curl -L https://downloads.getmonero.org/cli/linux64 -o monero.tar.bz2 && \
          tar xf monero.tar.bz2 -C ~ && \
          sudo install -g staff -m 0755 -o root ~/monero-*/*monero* -t /usr/local/bin/"
    - unless: qvm-run --pass-io {{ monero_daemon_vm }} "which monerod"

create_qrexec_action:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_daemon_vm }} \
          "sudo mkdir -p /rw/usrlocal/etc/qubes-rpc && \
          echo 'socat STDIO TCP:localhost:18081' | sudo tee /rw/usrlocal/etc/qubes-rpc/whonix.monerod-mainnet"

fix_qrexec_permissions:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_daemon_vm }} "sudo chmod 0644 /rw/usrlocal/etc/qubes-rpc/whonix.monerod-mainnet"

shutdown_daemon_vm:
  cmd.run:
    - name: |
        qvm-shutdown --wait {{ monero_daemon_vm }}

# 7. Set Up Wallet VM
install_wallet_binaries:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_wallet_vm }} \
          "sudo install -g staff -m 0755 -o root ~/QubesIncoming/{{ monero_daemon_vm }}/monero-* -t /usr/local/bin/"

configure_rc_local:
  cmd.run:
    - name: |
        qvm-run --pass-io {{ monero_wallet_vm }} \
          "echo 'socat TCP-LISTEN:18081,fork,bind=127.0.0.1 EXEC:\"qrexec-client-vm {{ monero_daemon_vm }} whonix.monerod-mainnet\" &' \
          | sudo tee -a /rw/config/rc.local && \
          sudo chmod +x /rw/config/rc.local"

shutdown_wallet_vm:
  cmd.run:
    - name: |
        qvm-shutdown --wait {{ monero_wallet_vm }}
