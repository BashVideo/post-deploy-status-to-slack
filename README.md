# post-deploy-status-to-slack
GitHub Action for updating deploy status in Slack

# Example

```
- uses: MoonriseCo/post-deploy-status-to-slack@master
  with:
    slack-webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    status: Started
```
