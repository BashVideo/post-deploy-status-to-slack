#!/bin/bash

if [ -z "$GITHUB_REF" ]; then
  DEPLOY_REF=$GITHUB_SHA
else
  DEPLOY_REF=$GITHUB_REF
fi

DEPLOY_REPOSITORY=$GITHUB_REPOSITORY
DEPLOY_LOG_URL="https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"

DEPLOY_STATUS=${DEPLOY_STATUS,,}
DEPLOY_REF=$(echo "$DEPLOY_REF" | sed "s/refs\/heads\///")
DEFAULT_DEPLOY_TEXT="Deploy #$DEPLOY_ID ($GITHUB_REPOSITORY#$DEPLOY_REF) status changed to $DEPLOY_STATUS"
DEPLOY_TEXT=${DEPLOY_TEXT:-"$DEFAULT_DEPLOY_TEXT"}

if [[ "$DEPLOY_STATUS" =~ 'started' ]]; then
  DEPLOY_COLOR="#aaaaaa"
elif [ "$DEPLOY_STATUS" == 'success' ]; then
  DEPLOY_COLOR="#36a64f"
else
  DEPLOY_COLOR="#ff0000"
fi

PAYLOAD=$(jq -n --arg text "$DEPLOY_TEXT" --arg color "$DEPLOY_COLOR" --arg user "$DEPLOY_USER" \
  --arg ref "<https://github.com/$DEPLOY_REPOSITORY/tree/$DEPLOY_REF|$DEPLOY_REPOSITORY#$DEPLOY_REF>" \
  --arg commit "<https://github.com/$DEPLOY_REPOSITORY/commit/$GITHUB_SHA|$GITHUB_SHA>" \
  --arg env "$DEPLOY_ENVIRONMENT" --arg deployment "ID: $DEPLOY_ID <$DEPLOY_LOG_URL|Logs>" \
'
{
  attachments:
  [{
    text: $text,
    color: $color,
    fields: [
      { title: "User", value: $user },
      { title: "Ref", value: $ref },
      { title: "Commit", value: $commit },
      { title: "Environment", value: $env },
      { title: "GitHub Deployment", value: $deployment }
    ]
  }]
}')

curl -X POST -H "Content-Type: application/json" --data "$PAYLOAD" $SLACK_WEBHOOK_URL
