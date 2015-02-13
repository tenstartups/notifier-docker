#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
ICON_EMOJI="${ICON_EMOJI:-''}"
HOSTNAME="$(hostname | awk '{print toupper($0)}')"
USERNAME="${USERNAME:-$HOSTNAME}"

# Exit with error if required variables not provided
if [ -z "${SLACK_WEBHOOK_URL}" ]; then
  echo "Envrionment variable SLACK_WEBHOOK_URL must be set"
  exit 1
fi
if [ -z "${MESSAGE}" ]; then
  echo "Envrionment variable MESSAGE must be set"
  exit 1
fi

# Build the message payload
PAYLOAD="{\"username\": \"${USERNAME}\", \"icon_emoji\": \"${ICON_EMOJI}\", \"text\": \"${MESSAGE}\"}"

# Send the notification using the slack webhook endpoint
printf "Sending notification to slack channel... "
curl -s \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -X POST \
  -d "payload=${PAYLOAD}" \
  ${SLACK_WEBHOOK_URL} \
  >/dev/null
echo "done."
