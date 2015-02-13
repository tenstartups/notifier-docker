#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
ICON_EMOJI="${ICON_EMOJI:-''}"
USERNAME="${USERNAME}:-`hostname | awk '{print toupper($0)}'`"
ATTACHMENT_MIME_TYPE="${ATTACHMENT_MIME_TYPE:-text/plain}"

# Exit with error if required variables not provided
if [ -z "${SLACK_WEBHOOK_URL}" ]; then
  echo "Envrionment variable SLACK_WEBHOOK_URL must be set"
  exit 1
fi
if [ -z "${MESSAGE}" ]; then
  echo "Envrionment variable MESSAGE must be set"
  exit 1
fi

# Build the message with or without attachment
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  printf "Sending slack channel message with file ${FILE_ATTACHMENT}... "
  PAYLOAD="{\"username\": \"${USERNAME}\", \"icon_emoji\": \"${ICON_EMOJI}\", \"text\": \"${MESSAGE}\"}"
else
  printf "Sending slack channel message... "
  PAYLOAD="{\"username\": \"${USERNAME}\", \"icon_emoji\": \"${ICON_EMOJI}\", \"text\": \"${MESSAGE}\"}"
fi

# Send the message to the webhook URL
curl -s \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X POST \
  -d "payload=${PAYLOAD}" \
  ${SLACK_WEBHOOK_URL} \
  >/dev/null
echo "done."
