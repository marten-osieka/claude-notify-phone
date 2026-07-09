#!/bin/bash
# Sends a Telegram notification to a phone via a Telegram bot.
# Usage: ./send_notification.sh "message text"
#
# Credentials are read from (in order of priority):
#   1. Environment variables TELEGRAM_BOT_TOKEN / TELEGRAM_CHAT_ID
#   2. A config.env file next to this script (see config.env.example)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.env"

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
  echo "Error: TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set (env vars or scripts/config.env)." >&2
  echo "See SKILL.md for setup instructions." >&2
  exit 1
fi

MESSAGE="${1:-Notification from Claude.}"

HTTP_CODE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  --data-urlencode "text=${MESSAGE}" \
  -o /dev/null -w "%{http_code}")

echo "$HTTP_CODE"

if [ "$HTTP_CODE" != "200" ]; then
  exit 1
fi
