#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"
HOSTNAME="$(hostname | awk '{print toupper($0)}')"

# Exit with error if required variables not provided
if [ -z "${MAILGUN_DOMAIN}" ]; then
  echo "Envrionment variable MAILGUN_DOMAIN must be set"
  exit 1
fi
if [ -z "${MAILGUN_API_KEY}" ]; then
  echo "Envrionment variable MAILGUN_API_KEY must be set"
  exit 1
fi
if [ -z "${MAILGUN_FROM}" ]; then
  echo "Envrionment variable MAILGUN_FROM must be set"
  exit 1
fi
if [ -z "${MAILGUN_TO}" ]; then
  echo "Envrionment variable MAILGUN_TO must be set"
  exit 1
fi
if [ -z "${MESSAGE}" ]; then
  echo "Envrionment variable MESSAGE must be set"
  exit 1
fi

# Send the associated file attachment if present
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  printf "Sending mailgun email notification with file ${FILE_ATTACHMENT}... "
  curl -s --user "${MAILGUN_API_KEY}" \
    "https://api.mailgun.net/v2/${MAILGUN_DOMAIN}/messages" \
    -F from="${MAILGUN_FROM}" \
    -F to="${MAILGUN_TO}" \
    -F subject="(${HOSTNAME}) ${MESSAGE}" \
    -F text="See attached log file for details." \
    --form-string html="<html>See attached log file for details.</html>" \
    -F attachment="@${FILE_ATTACHMENT}" \
    >/dev/null
  echo "done."
else
  printf "Sending mailgun email notification... "
  curl -s --user "${MAILGUN_API_KEY}" \
    "https://api.mailgun.net/v2/${MAILGUN_DOMAIN}/messages" \
    -F from="${MAILGUN_FROM}" \
    -F to="${MAILGUN_TO}" \
    -F subject="(${HOSTNAME}) ${MESSAGE}" \
    -F text="(${HOSTNAME}) ${MESSAGE}" \
    --form-string html="<strong><em>${HOSTNAME}</em></strong> ${MESSAGE}" \
    >/dev/null
  echo "done."
fi
