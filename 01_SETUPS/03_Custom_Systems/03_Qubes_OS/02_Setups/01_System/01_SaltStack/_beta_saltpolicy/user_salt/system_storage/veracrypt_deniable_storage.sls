# vim:ft=sls
# SaltStack policy for setting up deniable storage using VeraCrypt

install_veracrypt:
  pkg.installed:
    - name: veracrypt
    - refresh: true

setup_outer_container:
  cmd.run:
    - name: |
        veracrypt --text --create \
          --volume-type=normal \
          --size=15G \
          --encryption=AES \
          --hash=SHA-512 \
          --filesystem=ext4 \
          --password="outer_password" \
          /path/to/outer_container.tc
    - unless: test -f /path/to/outer_container.tc
    - require:
      - pkg: install_veracrypt

setup_hidden_container:
  cmd.run:
    - name: |
        veracrypt --text --create \
          --volume-type=hidden \
          --size=200M \
          --encryption=AES \
          --hash=SHA-512 \
          --filesystem=ext4 \
          --password="hidden_password" \
          --outer-volume-password="outer_password" \
          /path/to/outer_container.tc
    - require:
      - cmd: setup_outer_container

mount_deniable_storage:
  cmd.run:
    - name: |
        veracrypt --text \
          --mount /path/to/outer_container.tc /mnt/deniable_storage \
          --password="outer_password"
    - require:
      - cmd: setup_hidden_container

# Optional: Manage permissions for the mounted container
set_permissions:
  file.directory:
    - name: /mnt/deniable_storage
    - user: user
    - group: user
    - mode: 0700
    - require:
      - cmd: mount_deniable_storage
