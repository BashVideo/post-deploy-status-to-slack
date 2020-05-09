#!/bin/bash

export DEPLOY_ID="$1"
export DEPLOY_ENVIRONMENT="$2"
export DEPLOY_USER="$3"
export SLACK_WEBHOOK_URL=${SLACK_WEBHOOK_URL:-$4}
export DEPLOY_STATUS="$5"
export DEPLOY_TEXT="$6"

/bin/bash /slack-update.sh
