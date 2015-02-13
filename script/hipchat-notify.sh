#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
NOTICE_COLOR=${NOTICE_COLOR:-yellow}
ATTACHMENT_MIME_TYPE="${ATTACHMENT_MIME_TYPE:-text/plain}"

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

# Send the notification
printf "Sending hipchat room notification... "
curl -s \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Bearer ${HIPCHAT_AUTH_TOKEN}" \
  -X POST \
  -d "color=${NOTICE_COLOR}" \
  -d "message_format=text" \
  -d "message=${MESSAGE}" \
  https://api.hipchat.com/v2/room/${HIPCHAT_ROOM_ID}/notification \
  >/dev/null
echo "done."

# Send the associated file attachment if present
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  printf "Sharing file ${FILE_ATTACHMENT} in hipchat room... "
  curl -s \
    -H "Content-Type: multipart/related" \
    -H "Authorization: Bearer ${HIPCHAT_AUTH_TOKEN}" \
    -F "file=@${FILE_ATTACHMENT};type=${ATTACHMENT_MIME_TYPE}" \
    -X POST \
    https://api.hipchat.com/v2/room/${HIPCHAT_ROOM_ID}/share/file \
    >/dev/null
  echo "done."
fi
