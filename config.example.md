# Personal Configuration

Copy this file to `.claude/config.local.md` and edit to match your environment.

## Calendar

- tool: gcalcli
- path: /usr/local/bin/gcalcli
- calendars:
  - your-email@example.com

## Slack

- enabled: false

Webhook URL should be set in `.env` as `SLACK_WEBHOOK_URL`.

## GitHub

- assignee: @me
- repos:
  - owner/repo-name
