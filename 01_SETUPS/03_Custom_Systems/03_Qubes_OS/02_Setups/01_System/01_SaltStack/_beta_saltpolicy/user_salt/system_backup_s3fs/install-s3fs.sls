install-s3fs:
  cmd.run:
    - name: |
        if ! command -v s3fs &> /dev/null; then
          qubes-dom0-update -y s3fs
        fi
    - shell: /bin/bash
