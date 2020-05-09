#!/bin/bash

DEFAULT_DEPLOY_TEXT="Deploy status changed to $DEPLOY_STATUS"
DEPLOY_TEXT=${DEPLOY_TEXT:-"$DEFAULT_DEPLOY_TEXT"}

if [ "$DEPLOY_STATUS" == 'Started' ]; then
  DEPLOY_COLOR="#aaaaaa"
elif [ "$DEPLOY_STATUS" == 'Success' ]; then
  DEPLOY_COLOR="#36a64f"
else
  DEPLOY_COLOR="#ff0000"
fi

PAYLOAD=$(jq -n --arg text "$DEPLOY_TEXT" --arg color "$DEPLOY_COLOR" --arg user "$DEPLOY_USER" \
  --arg ref "<https://github.com/$DEPLOY_REPOSITORY/tree/$DEPLOY_REF|$DEPLOY_REPOSITORY#$DEPLOY_REF>" \
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
      { title: "Environment", value: $env },
      { title: "GitHub Deployment", value: $deployment }
    ]
  }]
}')

echo $PAYLOAD
curl -X POST -H "Content-Type: application/json" --data "$PAYLOAD" $SLACK_WEBHOOK_URL
