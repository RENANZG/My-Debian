#!/bin/bash

# Define file paths
IMG_FILE="tails_data/tails.img"
SIG_FILE="tails_data/tails.img.sig"
KEY_FILE="tails_data/tails-signing.key"
KEY_FINGERPRINT="A490D0F4D311A4153E2BB7CADBB802B258ACD84F"

# Step 1: Import the public key
echo "Importing the signing key..."
gpg --import "$KEY_FILE"

# Step 2: Set the key as ultimately trusted by editing the trust database directly
echo "Setting the key as ultimately trusted..."
echo "$KEY_FINGERPRINT:6:" | gpg --import-ownertrust

# Step 3: Verify the signature of the image file
echo "Verifying the signature..."
gpg --verify "$SIG_FILE" "$IMG_FILE"

# Step 4: Check if verification succeeded
if [ $? -eq 0 ]; then
    echo "Verification successful: The file's integrity and authenticity are intact."
else
    echo "Verification failed: The file's integrity or authenticity could not be verified."
fi
