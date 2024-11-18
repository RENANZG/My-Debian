#!/bin/bash

TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
COMMAND="$1"

case $COMMAND in
  status)
    STATUS=$(systemctl is-active apache2)
    MESSAGE="Apache2 status: $STATUS"
    ;;
  disk)
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    MESSAGE="Disk usage: $DISK_USAGE%"
    ;;
  *)
    MESSAGE="Unknown command: $COMMAND"
    ;;
esac

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
  -d chat_id=$CHAT_ID \
  -d text="$MESSAGE"
