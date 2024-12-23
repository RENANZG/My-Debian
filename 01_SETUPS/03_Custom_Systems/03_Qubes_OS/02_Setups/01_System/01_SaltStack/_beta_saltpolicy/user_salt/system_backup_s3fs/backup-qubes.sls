perform-backup:
  cmd.run:
    - name: |
        BACKUP_FILE="/mnt/s3-backup/qubes-backup-$(date +%Y-%m-%d).tar.gz"
        qubes-backup --yes --compress --destination "$BACKUP_FILE"
    - shell: /bin/bash
    - require:
        - cmd: mount-s3-bucket
