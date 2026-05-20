---
name: configure-notifications
description: Configure OMX notifications - unified portable entry point
triggers:
  - "configure notifications"
  - "setup notifications"
  - "notification settings"
  - "configure discord"
  - "configure telegram"
  - "configure slack"
  - "setup discord"
  - "setup telegram"
  - "setup slack"
  - "discord notifications"
  - "telegram notifications"
  - "slack notifications"
  - "discord webhook"
  - "telegram bot"
  - "slack webhook"
---

# Configure OMX Notifications

Use this skill to configure notification delivery in a user-owned environment.
Never ship credentials, webhook URLs, channel IDs, bot tokens, or local machine
commands inside a public repository. Ask the user for destination-specific values
at setup time and store them only in the local config file.

Config file:

```bash
CONFIG_FILE="$HOME/.codex/.omx-config.json"
```

## Step 1: Inspect Current State

```bash
if [ -f "$CONFIG_FILE" ]; then
  jq -r '
    {
      notifications_enabled: (.notifications.enabled // false),
      discord: (.notifications.discord.enabled // false),
      discord_bot: (.notifications["discord-bot"].enabled // false),
      telegram: (.notifications.telegram.enabled // false),
      slack: (.notifications.slack.enabled // false),
      custom_webhook_command: (.notifications.custom_webhook_command.enabled // false),
      custom_cli_command: (.notifications.custom_cli_command.enabled // false),
      verbosity: (.notifications.verbosity // "session"),
      idleCooldownSeconds: (.notifications.idleCooldownSeconds // 60),
      reply_enabled: (.notifications.reply.enabled // false)
    }
  ' "$CONFIG_FILE"
else
  echo "NO_CONFIG_FILE"
fi
```

## Step 2: Choose A Target

Use AskUserQuestion with these options:

1. Discord webhook
2. Discord bot
3. Telegram bot
4. Slack incoming webhook
5. Generic webhook command
6. Generic CLI command
7. Cross-cutting settings
8. Disable all notifications

## Step 3: Configure Native Targets

Collect values from the user during setup. Do not hardcode them in this skill.

- Discord webhook: `notifications.discord`
- Discord bot: `notifications["discord-bot"]`
- Telegram: `notifications.telegram`
- Slack: `notifications.slack`

For any token, webhook URL, or channel/chat identifier, remind the user that the
value belongs in their local config or secret manager, never in a repository.

## Step 4: Generic Webhook Command

Collect:

- URL
- Optional headers
- Optional method, default `POST`
- Optional events, default `session-end` and `ask-user-question`
- Optional instruction template

Write:

```bash
jq \
  --arg url "$URL" \
  --arg method "${METHOD:-POST}" \
  --arg instruction "${INSTRUCTION:-OMX event {{event}} for {{projectPath}}}" \
  '.notifications = (.notifications // {enabled: true}) |
   .notifications.enabled = true |
   .notifications.custom_webhook_command = {
     enabled: true,
     url: $url,
     method: $method,
     instruction: $instruction,
     events: ["session-end", "ask-user-question"]
   }' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
```

## Step 5: Generic CLI Command

Collect:

- Command template supporting `{{event}}`, `{{instruction}}`, `{{sessionId}}`,
  and `{{projectPath}}`
- Optional event list
- Optional instruction template
- Timeout expectations for long-running commands

Require placeholders instead of concrete local paths, usernames, hosts, or
passwords. If the command needs authentication, require environment variables or
a local secret manager.

Write:

```bash
jq \
  --arg command "$COMMAND_TEMPLATE" \
  --arg instruction "${INSTRUCTION:-OMX event {{event}} for {{projectPath}}}" \
  '.notifications = (.notifications // {enabled: true}) |
   .notifications.enabled = true |
   .notifications.custom_cli_command = {
     enabled: true,
     command: $command,
     instruction: $instruction,
     events: ["session-end", "ask-user-question"]
   }' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
```

## Step 6: Cross-Cutting Settings

Set only the requested fields:

- `notifications.verbosity`: `minimal`, `session`, `agent`, or `verbose`
- `notifications.idleCooldownSeconds`
- `notifications.profiles`
- `notifications.defaultProfile`
- `notifications.reply.enabled`

## Step 7: Disable All Notifications

```bash
jq '.notifications.enabled = false' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
```

## Step 8: Verify

After writing config, inspect it and run the lightest project-specific smoke
test available:

```bash
jq '.notifications' "$CONFIG_FILE"
```

Final summary should include:

- Enabled platforms
- Enabled generic aliases
- Verbosity and idle cooldown
- Reply listener state
- Config path
