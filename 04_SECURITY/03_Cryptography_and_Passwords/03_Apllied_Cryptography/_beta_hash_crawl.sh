#!/bin/bash

# URL of the page to capture
URL="https://twitter.com/example"

# Directory to store captured evidence
EVIDENCE_DIR="/path/to/evidence"

# Capture the webpage as a WARC file
wget --warc-file="$EVIDENCE_DIR/page" --warc-cdx --no-check-certificate -p "$URL"

# Generate hash of the WARC file
sha256sum "$EVIDENCE_DIR/page.warc.gz" > "$EVIDENCE_DIR/page_hash.txt"

# Optionally, submit the hash to a timestamp service (e.g., OpenTimestamps)
ots stamp "$EVIDENCE_DIR/page_hash.txt"

# Optionally, sign the hash with GPG
gpg --sign "$EVIDENCE_DIR/page_hash.txt"

# Store all evidence in a secure repository
cd "$EVIDENCE_DIR"
git init
git add page.warc.gz page_hash.txt
git commit -m "Captured and hashed $URL on $(date)"

# Optionally, push to a remote secure git repository
git remote add origin git@example.com:forensics/evidence.git
git push origin master
