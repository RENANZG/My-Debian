#!/bin/bash

TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

# Generate dynamic content
DATE=$(date +"%Y-%m-%d %H:%M:%S")
STATUS=$(systemctl is-active apache2) # Example of a status check

MESSAGE="Status Report:\nDate: $DATE\nApache2 Status: $STATUS"

# Send the message
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
  -d chat_id=$CHAT_ID \
  -d text="$MESSAGE" \
  -d parse_mode=Markdown
