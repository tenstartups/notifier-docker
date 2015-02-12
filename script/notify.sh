#!/bin/bash +x
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Send to each service requested
if [[ "${NOTIFY_TRANSPORTS}" =~ slack   ]]; then "${SCRIPT_DIR}/slack-notify"   "$@"; fi
if [[ "${NOTIFY_TRANSPORTS}" =~ hipchat ]]; then "${SCRIPT_DIR}/hipchat-notify" "$@"; fi
if [[ "${NOTIFY_TRANSPORTS}" =~ mailgun ]]; then "${SCRIPT_DIR}/mailgun-notify" "$@"; fi
