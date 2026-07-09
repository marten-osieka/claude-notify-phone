# claude-notify-phone

A Claude skill (for Claude Code / Claude Cowork) that lets Claude push a notification straight to your phone via Telegram — so it can tell you when it needs input, when a task finishes, or when something breaks, instead of you having to keep checking the chat.

## What it does

Once installed, Claude will use this skill to send you a Telegram push notification when:

- You explicitly ask to be notified/pinged/reminded
- Claude is blocked mid-task and needs a decision, credential, or confirmation from you
- A long-running task (build, research job, batch process, scheduled task) finishes
- Something errors out in a way you should know about right away

It deliberately does **not** ping for routine progress steps — just the moments that need your attention.

## Requirements

- A Telegram account
- `curl` and `bash` available in the environment Claude runs in

## Setup

1. **Create a bot.** In Telegram, message **[@BotFather](https://t.me/BotFather)**, send `/newbot`, and follow the prompts (choose a name and a username ending in `bot`). BotFather gives you a **bot token** — copy it.
2. **Message your bot.** Search for your bot's username in Telegram and send it any message (e.g. "hi"). This registers your chat with the bot.
3. **Get your chat ID.** Open this URL in a browser, replacing `<TOKEN>`:
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```
   Find `"chat":{"id":NUMBER, ...}` in the response — that number is your chat ID.
4. **Configure credentials.**
   ```bash
   cp scripts/config.env.example scripts/config.env
   ```
   Edit `scripts/config.env` and fill in `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`. (Environment variables of the same names also work, and take priority over the file.)
5. **Install the skill** in Claude Code or Cowork by pointing it at this directory (or packaging it as a `.skill` file, if your Claude client supports that).
6. **Test it:**
   ```bash
   bash scripts/send_notification.sh "Setup test — it works!"
   ```
   You should get a Telegram push immediately.

## Usage

Claude calls this directly:

```bash
bash scripts/send_notification.sh "Your message here"
```

Prints `200` on success. Prints Telegram's error body and exits non-zero on failure.

## Security notes

- `scripts/config.env` is gitignored — never commit real credentials.
- The bot token grants control over that one bot only, not your Telegram account.
- Messages are not end-to-end encrypted — don't send secrets, passwords, or sensitive personal data through it.

## License

MIT — do whatever you want with it.
