# AI Standards For Antigravity

This directory is installed to `{{USER_HOME}}/.ai-standards`.

It gives Antigravity a portable standards root that points back to Orquestrador Maestro without exposing a real user path. Use it as compact global context before opening larger skill files.

Primary files:

- `core/rules.md`: operating contract.
- `core/workflow.md`: execution flow.
- `core/orchestrator.md`: Orquestrador/Maestro roles.
- `core/integration.md`: tool integration rules.
- `core/patterns.md`: reusable implementation patterns.
- `templates/session.md`: compact session note template.
- `templates/log.md`: compact worklog template.

Antigravity should read the project `AGENTS.md`, then `DEV/` overview docs when present, then the selected task skill.
