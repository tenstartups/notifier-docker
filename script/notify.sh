#!/bin/bash +x
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Warn if not notifier services present
if [ -z "${NOTIFIER_SERVICES}" ]; then
  echo "No notifier services specified; use the NOTIFIER_SERVICES environment variable to set them"
fi

# Send to each service requested
if [[ "${NOTIFIER_SERVICES}" =~ slack   ]]; then "${SCRIPT_DIR}/slack-notify"   "$@"; fi
if [[ "${NOTIFIER_SERVICES}" =~ hipchat ]]; then "${SCRIPT_DIR}/hipchat-notify" "$@"; fi
if [[ "${NOTIFIER_SERVICES}" =~ mailgun ]]; then "${SCRIPT_DIR}/mailgun-notify" "$@"; fi
