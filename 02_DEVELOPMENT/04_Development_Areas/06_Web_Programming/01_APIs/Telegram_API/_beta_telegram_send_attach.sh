#!/bin/bash

TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
PHOTO_PATH="/path/to/photo.jpg"

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendPhoto" \
  -F chat_id=$CHAT_ID \
  -F photo=@$PHOTO_PATH \
  -F caption="Here is a photo"
