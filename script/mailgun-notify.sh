#!/bin/bash +x
set -e

# Set environment
MESSAGE="${MESSAGE:-$1}"

# Exit with error if required variables not provided
if [ -z "${MAILGUN_DOMAIN}" ]; then
  echo "Envrionment variable MAILGUN_DOMAIN must be set"
  exit 1
fi
if [ -z "${MAILGUN_API_KEY}" ]; then
  echo "Envrionment variable MAILGUN_API_KEY must be set"
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

# Set the from address if not specified
MAILGUN_FROM="${MAILGUN_FROM:-`hostname | awk '{print toupper($0)}'`@$MAILGUN_DOMAIN}"

# Send the associated file attachment if present
if ! [ -z "${FILE_ATTACHMENT}" ] && [ -f "${FILE_ATTACHMENT}" ]; then
  printf "Sending mailgun email notification with file ${FILE_ATTACHMENT}... "
  curl -s --user "${MAILGUN_API_KEY}" \
    "https://api.mailgun.net/v2/${MAILGUN_DOMAIN}/messages" \
    -F from="${MAILGUN_FROM}" \
    -F to="${MAILGUN_TO}" \
    -F subject="${MESSAGE}" \
    -F text="${MESSAGE}" \
    --form-string html="${MESSAGE}" \
    -F attachment="@${FILE_ATTACHMENT}" \
    >/dev/null
  echo "done."
else
  printf "Sending mailgun email notification... "
  curl -s --user "${MAILGUN_API_KEY}" \
    "https://api.mailgun.net/v2/${MAILGUN_DOMAIN}/messages" \
    -F from="${MAILGUN_FROM}" \
    -F to="${MAILGUN_TO}" \
    -F subject="${MESSAGE}" \
    -F text="${MESSAGE}" \
    --form-string html="${MESSAGE}" \
    >/dev/null
  echo "done."
fi
