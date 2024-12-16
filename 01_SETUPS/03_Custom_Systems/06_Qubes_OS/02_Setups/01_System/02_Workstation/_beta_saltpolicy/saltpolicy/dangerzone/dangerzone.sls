# vim:ft=sls
# SaltStack policy for Dangerzone in Qubes OS
# Applying the Policy
# sudo salt-call state.apply dangerzone

# Ensure required Dangerzone package is installed in the template VM
install_dangerzone_template:
  cmd.run:
    - name: |
        qvm-run --pass-io fedora-40 \
          "sudo dnf config-manager --add-repo=https://packages.freedom.press/yum-tools-prod/dangerzone/dangerzone.repo && \
           sudo rpm --import https://packages.freedom.press/yum-tools-prod/dangerzone/repodata/repomd.xml.key && \
           sudo dnf install -y dangerzone-qubes"
    - unless: qvm-run --pass-io fedora-40 "rpm -q dangerzone-qubes"
    - require:
        - qvm: ensure_template

# Ensure template VM exists
ensure_template:
  qvm.template_installed:
    - name: fedora-40

# Configure Dangerzone (if required) in the template VM
configure_dangerzone:
  file.managed:
    - name: /etc/dangerzone/dangerzone.conf
    - source: salt://dangerzone/dangerzone.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
        - cmd: install_dangerzone_template

# Ensure AppVM for Dangerzone DispVM exists
create_dangerzone_appvm:
  qvm.present:
    - name: dz-template
    - label: red
    - template: fedora-40
    - class: AppVM

# Ensure preferences for the AppVM
configure_dangerzone_appvm:
  qvm.prefs:
    - name: dz-template
    - netvm: ''
    - template_for_dispvms: True

# Create Dangerzone DispVM
create_dangerzone_dispvm:
  qvm.present:
    - name: disp-dz
    - label: red
    - template: dz-template
    - class: DispVM

# Configure RPC policy for Dangerzone
configure_rpc_policy:
  file.managed:
    - name: /etc/qubes/policy.d/50-dangerzone.policy
    - contents: |
        dz.Convert         *       @anyvm       @dispvm:disp-dz  allow
    - user: root
    - group: root
    - mode: 0644
