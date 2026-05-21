# Antigravity Rules

Antigravity must use Orquestrador Maestro as the default operating contract for this user.

Read first:

1. `{{USER_HOME}}/AGENTS.md`
2. `{{USER_HOME}}/.orquestrador/rules.md`
3. `{{USER_HOME}}/.orquestrador/maestro.md`
4. nearest project `AGENTS.md`
5. project `DEV/README.md`, `DEV/INDEX.md` or `DEV/CONTEXT.md` when present
6. the task-relevant skill

Operating rules:

- Treat the assistant as the Orquestrador and the user as the Maestro.
- Use `{{USER_HOME}}/.orquestrador/SKILLS_ROUTER.json` before loading skill bodies.
- Load only the task-relevant `SKILL.md` files.
- Keep durable project documentation in `DEV/` by default.
- Update `DEV/WORKLOG.md` after substantive project work.
- Verify before claiming completion.
- Do not commit or push unless the user explicitly asks.
- Never expose tokens, credentials, local logs, caches, backups, private paths or local project memory.
