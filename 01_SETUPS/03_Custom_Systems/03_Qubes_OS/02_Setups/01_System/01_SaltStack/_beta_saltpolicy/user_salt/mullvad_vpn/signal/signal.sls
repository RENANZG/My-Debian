# SaltStack configuration for Signal in Qubes OS

{% if grains['id'] == 'dom0' %}

install-debian-12-minimum:
  cmd.run:
    - name: qvm-template install debian-12-minimum
    - unless: qvm-ls | grep -q debian-12-minimum

vms-depends:
  qvm.template_installed:
    - name: debian-12-minimum

clone-signal-template:
  qvm.clone:
    - name: signal-template
    - source: debian-12-minimum

signal-appvm-present:
  qvm.present:
    - name: signal
    - template: signal-template
    - label: yellow
    - class: AppVM

signal-appvm-prefs:
  qvm.prefs:
    - name: signal
    - netvm: sys-whonix

signal-appvm-features:
  qvm.features:
    - name: signal
    - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy
        - service.tracker
        - service.evolution-data-server
    - set:
        - menu-items: qubes-start.desktop signal-desktop.desktop


setup-signal-firewall:
  cmd.run:
    - name: |
        # Reset any existing rules
        qvm-firewall signal reset &&

        # Allow all necessary domains for Signal
        qvm-firewall signal add accept signal.org tcp 443 &&
        qvm-firewall signal add accept storage.signal.org tcp 443 &&
        qvm-firewall signal add accept chat.signal.org tcp 443 &&
        qvm-firewall signal add accept cdn.signal.org tcp 443 &&
        qvm-firewall signal add accept cdn2.signal.org tcp 443 &&
        qvm-firewall signal add accept turn.voip.signal.org udp &&
        qvm-firewall signal add accept turn2.voip.signal.org udp &&
        qvm-firewall signal add accept turn3.voip.signal.org udp &&
        qvm-firewall signal add accept sfu.voip.signal.org udp &&
        qvm-firewall signal add accept signal.art tcp 443 &&
        qvm-firewall signal add accept signal.group tcp 443 &&
        qvm-firewall signal add accept signal.link tcp 443 &&
        qvm-firewall signal add accept signal.me tcp 443 &&
        qvm-firewall signal add accept signal.tube tcp 443 &&

        # Add specific requirements for group and 1:1 calls
        qvm-firewall signal add accept signal.org udp 10000 &&
        qvm-firewall signal add accept signal.org udp 3478 &&

        # Allow all UDP traffic to ensure seamless communication
        qvm-firewall signal add accept signal.org udp &&

        # Optional: Allow wildcard FQDNs if supported
        qvm-firewall signal add accept *.signal.org tcp 443 &&
        qvm-firewall signal add accept *.signal.org udp &&

        echo "Signal firewall rules configured successfully."
    - unless: qvm-firewall signal list | grep signal.org

{% elif grains['id'] == 'signal-template' %}

install-signal-keyring:
  cmd.run:
    - name: |
        curl --proxy http://127.0.0.1:8082/ --tlsv1.2 --proto =https --max-time 180 \
        -0 https://updates.signal.org/desktop/apt/keys.asc | \
        gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg
    - unless: test -f /usr/share/keyrings/signal-desktop-keyring.gpg

add-signal-repo:
  file.managed:
    - name: /etc/apt/sources.list.d/signal-xenial.list
    - contents: deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main
    - mode: '0644'
    - user: root
    - group: root

update-and-install-signal:
  pkg.installed:
    - pkgs:
        - signal-desktop
    - refresh: True

{% elif grains['id'] == 'signal' %}

setup-desktop-autostart:
  file.symlink:
    - name: /home/user/.config/autostart/signal-desktop.desktop
    - target: /usr/share/applications/signal-desktop.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

{% endif %}
