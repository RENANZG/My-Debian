You can use gocryptfs, present in Cryptomator and SiriKali, to encrypt data stored inside the mounted s3fs storage.

Even if someone gains access to your S3 bucket, they cannot decrypt the files without the encryption key. Local Encryption: Files are encrypted on your machine before being uploaded to S3, ensuring no plaintext data is exposed.

Consider using deniable encryption in contexts where the ability to deny possession of information is critical.

How to Set Up gocryptfs with s3fs
1. Install Dependencies

Make sure you have gocryptfs installed.

sudo apt install gocryptfs

2. Mount Your S3 Bucket

Using s3fs, mount the S3 bucket to a local directory (e.g., /mnt/s3-backup).

s3fs your-bucket-name /mnt/s3-backup -o passwd_file=/root/.passwd-s3fs -o use_path_request_style -o url=https://s3.amazonaws.com

3. Initialize gocryptfs Encrypted Filesystem

Create an encrypted folder inside the mounted S3 bucket.

mkdir /mnt/s3-backup/encrypted
gocryptfs -init /mnt/s3-backup/encrypted

    This command initializes an encrypted directory and asks for a password to secure the encryption key.
    The password will be required every time you access the encrypted data.

4. Mount the Encrypted Filesystem

Mount the encrypted directory to a local folder (e.g., /mnt/encrypted-data) for seamless access.

mkdir /mnt/encrypted-data
gocryptfs /mnt/s3-backup/encrypted /mnt/encrypted-data

    Any files copied to /mnt/encrypted-data will be automatically encrypted and stored in /mnt/s3-backup/encrypted.

5. Perform Backups

Now, you can perform backups to the /mnt/encrypted-data directory.
