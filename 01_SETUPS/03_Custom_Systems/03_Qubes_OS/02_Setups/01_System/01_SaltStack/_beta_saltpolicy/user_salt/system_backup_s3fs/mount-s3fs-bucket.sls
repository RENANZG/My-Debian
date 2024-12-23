mount-s3-bucket:
  cmd.run:
    - name: |
        mkdir -p /mnt/s3-backup
        s3fs bucket-backup /mnt/s3-backup -o passwd_file=/root/.passwd-s3fs -o use_path_request_style -o url=https://s3.amazonaws.com
    - shell: /bin/bash
    - require:
        - cmd: install-s3fs
        - file: setup-s3fs-credentials
