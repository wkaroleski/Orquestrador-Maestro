# Tool Integration

Antigravity should integrate with the same Orquestrador roots used by the other tools:

| Purpose | Path |
|---|---|
| Global contract | `{{USER_HOME}}/AGENTS.md` |
| Rules | `{{USER_HOME}}/.orquestrador/rules.md` |
| Maestro protocol | `{{USER_HOME}}/.orquestrador/maestro.md` |
| Hooks | `{{USER_HOME}}/.orquestrador/hooks.md` |
| Skills index | `{{USER_HOME}}/.orquestrador/SKILLS_INDEX.md` |
| Skills router | `{{USER_HOME}}/.orquestrador/SKILLS_ROUTER.json` |
| Antigravity skills mirror | `{{USER_HOME}}/.antigravity-skills/skills` |
| AI standards | `{{USER_HOME}}/.ai-standards` |

The installer writes:

- `{{USER_HOME}}/antigravity-rules.json`
- `{{USER_HOME}}/.antigravity/antigravity.json`
- `{{USER_HOME}}/.antigravity/settings.json`
- `{{USER_HOME}}/.ai-standards`
- `{{USER_HOME}}/.antigravity-skills/skills`

If a future Antigravity version moves its global settings, copy the same contract into the new global rule location.
