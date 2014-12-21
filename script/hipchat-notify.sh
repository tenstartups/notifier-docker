#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
NOTICE_COLOR=${NOTICE_COLOR:-yellow}
HOSTNAME="$(hostname | awk '{print toupper($0)}')"
ATTACHMENT_MIME_TYPE="${ATTACHMENT_MIME_TYPE:-text/plain}"

# Exit with error if required variables not provided
if [ "${HIPCHAT_AUTH_TOKEN}" == "" ]; then
  echo "Envrionment variable HIPCHAT_AUTH_TOKEN must be set"
  exit 1
fi
if [ "${HIPCHAT_ROOM_ID}" == "" ]; then
  echo "Envrionment variable HIPCHAT_ROOM_ID must be set"
  exit 1
fi
if [ "${MESSAGE}" == "" ]; then
  echo "Envrionment variable MESSAGE must be set"
  exit 1
fi

# Add a reference to the upcoming file attachment if we have one
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  MESSAGE="${MESSAGE}<br/>Refer to the file '`basename ${FILE_ATTACHMENT}`' attached in the next message..."
fi

# Send the notification
printf "Sending hipchat room notification... "
curl \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Bearer ${HIPCHAT_AUTH_TOKEN}" \
  -X POST \
  -d "color=${NOTICE_COLOR}" \
  -d "message_format=html" \
  -d "message=<strong><em>${HOSTNAME}</em></strong> ${MESSAGE}" \
  https://api.hipchat.com/v2/room/${HIPCHAT_ROOM_ID}/notification
echo "done."

# Send the associated file attachment if present
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  printf "Sharing file ${FILE_ATTACHMENT} in hipchat room... "
  curl \
    -H "Content-Type: multipart/related" \
    -H "Authorization: Bearer ${HIPCHAT_AUTH_TOKEN}" \
    -F "file=@${FILE_ATTACHMENT};type=${ATTACHMENT_MIME_TYPE}" \
    -X POST \
    https://api.hipchat.com/v2/room/${HIPCHAT_ROOM_ID}/share/file
  echo "done."
fi
