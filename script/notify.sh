#!/bin/bash +x
set -e

if [[ "${NOTIFY_TRANSPORTS}" =~ mailgun ]]; then mailgun-notify; fi
if [[ "${NOTIFY_TRANSPORTS}" =~ hipchat ]]; then hipchat-notify; fi
    
