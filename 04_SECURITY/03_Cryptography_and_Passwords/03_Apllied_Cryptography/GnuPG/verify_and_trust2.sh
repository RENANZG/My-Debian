#!/bin/bash

# Absolute paths
TAILS_DATA_DIR="tails_data"
TAILS_KEY_URL="https://tails.boum.org/tails-signing.key"
TAILS_SIG_URL="https://tails.boum.org/tails.img.sig"

# Make sure required directories exist
mkdir -p "$TAILS_DATA_DIR"

# Function to trust and verify Tails
verify_tails_image() {
  # Download the signing key and signature
  curl --retry 5 --retry-delay 10 --max-time 3600 -L -C - -o "$TAILS_DATA_DIR/tails-signing.key" "$TAILS_KEY_URL"
  curl --retry 5 --retry-delay 10 --max-time 3600 -L -C - -o "$TAILS_DATA_DIR/tails.img.sig" "$TAILS_SIG_URL"

  # Import the Tails developer key
  gpg --no-default-keyring --keyring "$TAILS_DATA_DIR/tmp_keyring.pgp" --import "$TAILS_DATA_DIR/tails-signing.key"

  # Verify the imported key fingerprint
  if ! gpg --no-default-keyring --keyring "$TAILS_DATA_DIR/tmp_keyring.pgp" --fingerprint 58ACD84F | grep -q "A490 D0F4 D311 A415 3E2B  B7CA DBB8 02B2 58AC D84F"; then
    echo -e "\nERROR! Invalid Tails developer key."
    exit 1
  fi
  echo -e "\n[+] Tails developer key verified."

  # Set trust level for the developer key
  echo -e "5\ny\n" | gpg --no-default-keyring --keyring "$TAILS_DATA_DIR/tmp_keyring.pgp" --command-fd 0 --edit-key "58ACD84F" trust > /dev/null

  # Verify the image signature
  if gpg --no-default-keyring --keyring "$TAILS_DATA_DIR/tmp_keyring.pgp" --verify "$TAILS_DATA_DIR/tails.img.sig" "$TAILS_DATA_DIR/tails.img" > /dev/null 2>&1; then
    echo -e "\n[+] The .img is valid."
  else
    echo -e "\nERROR! Image verification failed."
    exit 1
  fi
}

# Run the function
verify_tails_image
