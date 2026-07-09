---
name: notify-phone
description: Send a push notification to the user's phone via a private Telegram bot. Use this whenever the user asks to be notified, pinged, alerted, or reminded, and proactively for Claude Code / Cowork tasks that need the user's input, finish a long run, or hit an error — without over-notifying on routine progress steps.
---

# Notify Phone (Telegram)

Sends a message directly to the user's phone via a personal Telegram bot. Delivery is a near-instant push notification.

## Setup (one-time, per user)

1. **Create a bot.** In Telegram, message **@BotFather**, send `/newbot`, and follow the prompts (name + username ending in `bot`). BotFather returns a bot token like `123456789:ABCdef...` — copy it.
2. **Message your bot.** Search for the bot's username and send it any message (e.g. "hi"). This is required so Telegram knows which chat to deliver to.
3. **Get your chat ID.** Visit `https://api.telegram.org/bot<TOKEN>/getUpdates` in a browser (replace `<TOKEN>`). Find `"chat":{"id":NUMBER,...}` — that number is your chat ID.
4. **Configure credentials.** Copy `scripts/config.env.example` to `scripts/config.env` and fill in `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`. (Or set them as environment variables instead — the script checks env vars first, then `config.env`.)
5. **Test it:**
   ```bash
   bash scripts/send_notification.sh "Setup test — it works!"
   ```
   You should get a Telegram push immediately. A `200` printed means success.

`config.env` is gitignored — never commit real credentials if you fork/publish this skill.

## How to send a notification

```bash
bash scripts/send_notification.sh "Your message here"
```

Prints `200` on success. On failure it prints the Telegram error body and exits non-zero — treat that as the notification NOT having gone through.

## When to use this

Use it for moments that actually need the user's attention, not routine progress:

- The user explicitly asks to be notified/pinged/alerted.
- **Claude needs something from the user mid-task** — a decision, missing credential, confirmation, or any other blocker — send a short ping saying what's needed.
- **A long-running or multi-step task finishes** (a build, a research task, a batch job, a scheduled task) — one message summarizing the outcome.
- **Something breaks or errors out** in a way the user should know about right away.

Do NOT ping for: every intermediate step of a task, minor progress updates, or anything the user will see in the chat anyway a moment later.

## Guidelines

- Keep messages short and specific: what happened / what's needed, not a full report. E.g. "Report finished — 12 sources reviewed" or "Need your AWS key to continue" rather than the whole conversation.
- One notification per meaningful event — don't stack several for one task.
- Never put sensitive data (passwords, full financial details, secrets) in the message text — this bot is not end-to-end encrypted.
- If the send fails, tell the user in-chat that the notification didn't go through rather than assuming it did.
