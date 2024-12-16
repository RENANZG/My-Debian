{% if grains['os_family'] == 'RedHat' %}
{% if grains['os'] == 'Fedora' and grains['osmajorrelease'] < 33 %}
/usr/lib/rpm/macros.d/macros.qubes:
  file.managed:
    - contents: |
        # CVE-2021-20271 mitigation
        %_pkgverify_level all
{% else %}
{% if grains['os'] == 'Fedora' and grains['osmajorrelease'] < 41 %}
dnf-and-rpm:
  pkg.installed:
    - pkgs:
      - dnf: '>= 4.7.0'
      - rpm: '>= 4.14.2'

/usr/lib/rpm/macros.d/macros.qubes:
  file.absent:
    - require:
      - pkg: dnf-and-rpm
{% else %}
/usr/lib/rpm/macros.d/macros.qubes:
  file.absent: []
{% endif %}
{% endif %}
{% endif %}

# apply fix for #9025 to unbreak updates proxy
/etc/qubes-rpc/qubes.UpdatesProxy:
  # use file.replace instead of file.managed, to not interfere with future
  # possible changes
  file.replace:
  - ignore_if_missing: True
  - pattern: "STDIO TCP:localhost:8082"
  - repl: "STDIO TCP4:127.0.0.1:8082"

{% if grains['os_family'] == 'RedHat' %}
dnf-makecache:
  cmd.script:
    - source: salt://update/dnf-makecache
    - runas: root
    - stateful: True

Disable deltarpm:
  cmd.run:
    - name: echo deltarpm=False >> /etc/dnf/dnf.conf
    - unless: grep -q deltarpm=False /etc/dnf/dnf.conf
{% endif %}

{% if grains['oscodename'] == 'buster' %}
# https://bugs.debian.org/931566
# Apply the workaround manually, to be able to pull in the fixed apt version
apt-get update --allow-releaseinfo-change:
  cmd.run:
   - order: 1
{% endif %}

update:
  pkg.uptodate:
    - refresh: True
{% if grains['os'] == 'Debian' %}
    - dist_upgrade: True
{% elif grains['os_family'] == 'RedHat' %}
    - require:
      - cmd: dnf-makecache
      - file: /usr/lib/rpm/macros.d/macros.qubes
      - cmd: 'Disable deltarpm'
{% endif %}

notify-updates:
  cmd.run:
    - name: /usr/lib/qubes/upgrades-status-notify
