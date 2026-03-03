#!/usr/bin/env bash
set -euo pipefail

# Usage: bash scripts/notify-slack.sh <daily-log-file>
# Sends a daily log to Slack via Incoming Webhook.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <daily-log-file>" >&2
  exit 1
fi

FILE="$1"

if [[ ! -f "$FILE" ]]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

# Load .env
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: .env not found at $PROJECT_ROOT" >&2
  exit 1
fi

SLACK_WEBHOOK_URL=""
while IFS='=' read -r key value; do
  if [[ "$key" == "SLACK_WEBHOOK_URL" ]]; then
    SLACK_WEBHOOK_URL="$value"
  fi
done < "$ENV_FILE"

if [[ -z "$SLACK_WEBHOOK_URL" ]]; then
  echo "Error: SLACK_WEBHOOK_URL is not set in .env" >&2
  exit 1
fi

# Strip YAML frontmatter (lines between first and second ---)
content=$(awk '
  BEGIN { in_fm=0; done_fm=0 }
  /^---$/ {
    if (!done_fm) {
      if (in_fm) { done_fm=1; next }
      else { in_fm=1; next }
    }
  }
  done_fm { print }
' "$FILE")

# Convert Markdown to Slack mrkdwn:
#   ## Heading -> *Heading*
#   ### Heading -> *Heading*
#   **bold** -> *bold*
#   [text](url) -> <url|text>
slack_text=$(echo "$content" \
  | sed -E 's/^#{2,}[[:space:]]+(.*)/\*\1\*/' \
  | sed -E 's/\*\*([^*]+)\*\*/\*\1\*/g' \
  | sed -E 's/\[([^]]+)\]\(([^)]+)\)/<\2|\1>/g' \
)

# Remove leading blank lines
slack_text=$(echo "$slack_text" | sed '/./,$!d')

# Build JSON payload
filename=$(basename "$FILE" .md)
json_payload=$(jq -n --arg text "$slack_text" --arg title "$filename" '{
  blocks: [
    {
      type: "header",
      text: { type: "plain_text", text: ("Daily Log: " + $title) }
    },
    {
      type: "section",
      text: { type: "mrkdwn", text: $text }
    }
  ]
}')

# POST to Slack
http_status=$(curl -s -o /dev/stderr -w "%{http_code}" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "$json_payload" \
  "$SLACK_WEBHOOK_URL" 2>/dev/null)

if [[ "$http_status" == "200" ]]; then
  echo "Slack notification sent successfully."
  exit 0
else
  echo "Error: Slack API returned HTTP $http_status" >&2
  exit 1
fi
