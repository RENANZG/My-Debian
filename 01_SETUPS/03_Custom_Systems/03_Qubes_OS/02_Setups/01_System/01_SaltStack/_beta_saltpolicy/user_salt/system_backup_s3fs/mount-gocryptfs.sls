mount-gocryptfs:
  cmd.run:
    - name: |
        mkdir -p /mnt/s3-backup /mnt/encrypted-data
        s3fs bucket-backup /mnt/s3-backup -o passwd_file=/root/.passwd-s3fs
        echo -n "Enter gocryptfs password: "
        read -s GOCRYPTFS_PASSWORD
        echo
        echo $GOCRYPTFS_PASSWORD | gocryptfs -extpass "cat" /mnt/s3-backup/encrypted /mnt/encrypted-data
        unset GOCRYPTFS_PASSWORD
    - shell: /bin/bash
