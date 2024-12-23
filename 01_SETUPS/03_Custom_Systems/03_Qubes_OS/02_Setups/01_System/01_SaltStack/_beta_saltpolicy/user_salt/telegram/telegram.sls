# SaltStack configuration for creating a "Telegram" qube in Qubes OS

{% if grains['id'] == 'dom0' %}

install-debian-12-minimum:
  cmd.run:
    - name: qvm-template install debian-12-minimum
    - unless: qvm-ls | grep -q debian-12-minimum

vms-depends:
  qvm.template_installed:
    - name: debian-12-minimum

clone-telegram-template:
  qvm.clone:
    - name: telegram-template
    - source: debian-12-minimum

telegram-appvm-present:
  qvm.present:
    - name: telegram
    - template: telegram-template
    - label: yellow
    - class: AppVM

telegram-appvm-prefs:
  qvm.prefs:
    - name: telegram
    - netvm: sys-whonix

telegram-appvm-features:
  qvm.features:
    - name: telegram
    - set:
        menu-items: qubes-start.desktop org.telegram-desktop.desktop

{% elif grains['id'] == 'telegram-template' %}

telegram-install-package:
  pkg.installed:
    - pkgs:
      - telegram-desktop

{% endif %}
