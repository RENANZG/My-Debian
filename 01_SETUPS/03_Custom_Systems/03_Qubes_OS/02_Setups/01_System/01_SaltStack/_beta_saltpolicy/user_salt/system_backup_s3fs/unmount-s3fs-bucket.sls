unmount-s3-bucket:
  cmd.run:
    - name: umount /mnt/s3-backup
    - shell: /bin/bash
    - require:
        - cmd: perform-backup
