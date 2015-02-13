#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
HOSTNAME="$(hostname | awk '{print toupper($0)}')"
HIPCHAT_FROM="${HIPCHAT_FROM:-$HOSTNAME}"
HIPCHAT_FROM="$(echo $HIPCHAT_FROM | cut -c 1-15)"
NOTICE_COLOR=${NOTICE_COLOR:-yellow}

# Exit with error if required variables not provided
if [ -z "${HIPCHAT_AUTH_TOKEN}" ]; then
  echo "Envrionment variable HIPCHAT_AUTH_TOKEN must be set"
  exit 1
fi
if [ -z "${HIPCHAT_ROOM_ID}" ]; then
  echo "Envrionment variable HIPCHAT_ROOM_ID must be set"
  exit 1
fi
if [ -z "${MESSAGE}" ]; then
  echo "Envrionment variable MESSAGE must be set"
  exit 1
fi

# Send the notification using the hipchat API
printf "Sending notification to hipchat room... "
curl -s \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X POST \
  -d "auth_token=${HIPCHAT_AUTH_TOKEN}" \
  -d "format=json" \
  -d "room_id=${HIPCHAT_ROOM_ID}" \
  -d "from=${HIPCHAT_FROM}" \
  -d "color=${NOTICE_COLOR}" \
  -d "message_format=text" \
  -d "message=${MESSAGE}" \
  https://api.hipchat.com/v1/rooms/message \
  >/dev/null
echo "done."
