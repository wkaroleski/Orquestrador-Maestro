# Orquestrador Rules

Status: ativo
Local: `{{USER_HOME}}/.orquestrador\rules.md`

This is the compact global contract for agents on this machine.

## Non-Negotiable Rules

1. Do not auto-commit or auto-push. The human validates production changes.
2. Keep shared roots compatible. Do not remove `.agents`, `.opencode`, `.codex`, `.claude`, `.cursor`, `.gemini`, `.windsurf`, or `.antigravity-skills` unless explicitly requested.
3. Verify before claiming completion.
4. Prefer the smallest relevant context. Do not load full catalogs when a router/index is enough.
5. New reusable intelligence should be saved under `{{USER_HOME}}/.orquestrador` first, then synced outward.

## Command Hierarchy

1. `{{USER_HOME}}/.orquestrador\rules.md`
2. `{{USER_HOME}}/.orquestrador\maestro.md`
3. `{{USER_HOME}}/AGENTS.md`
4. nearest project `AGENTS.md`
5. current project `DEV/` documentation, when present
6. selected task skill

## Project DEV Documentation

When the current project contains a `DEV/` directory, treat it as the canonical project documentation and operational memory root. Read only an index or overview first, in this order when present: `DEV/AGENTS.md`, `DEV/README.md`, `DEV/INDEX.md`, `DEV/PROJECT.md`, `DEV/CONTEXT.md`.

After that, load only task-relevant files under `DEV/`, such as `ARCHITECTURE.md`, `DECISIONS.md`, `ADR/`, `API.md`, `DATABASE.md`, `TESTING.md`, `RUNBOOK.md`, `ROADMAP.md`, or `TASKS.md`. Existing sub-hierarchies such as `DEV/LOGS/`, `DEV/SQL/`, `DEV/ARCH/`, `DEV/WORKFLOWS/`, `DEV/TESTS/`, `DEV/DOCUMENTATION/`, and `DEV/BACKLOG/` are also valid. Do not bulk-load the entire `DEV/` tree by default.

Create durable project documentation under `DEV/` by default. After substantive work, append a compact entry to `DEV/WORKLOG.md` with what changed, why, verification, and next context. Update `DEV/INDEX.md` when DEV docs change and `DEV/CONTEXT.md` when project state, commands, architecture, environment, or risks change.

If project `AGENTS.md` conflicts with `DEV/` documentation, project `AGENTS.md` wins. `DEV/` documentation provides project context before global skills are applied.

Full convention: `{{USER_HOME}}/.orquestrador/PROJECT_DEV_HIERARCHY.md`.

## Quality Standards

- TypeScript: strict mode, avoid `any`, prefer explicit interfaces or `unknown` with guards.
- Imports: prefer configured absolute imports and stable grouping.
- Naming: components in PascalCase, hooks with `use` prefix, variables/functions in camelCase, constants in SCREAMING_SNAKE_CASE.
- Security: validate inputs, protect secrets, use least privilege, and keep Supabase RLS enabled when applicable.
- APIs: handle errors explicitly and avoid over-fetching.
- Frontend: keep UI responsive, readable, and consistent with the existing design system.

## Skill Discipline

Use `{{USER_HOME}}/.orquestrador\SKILLS_ROUTER.json` before opening skill files.

Load only the skill files needed for the task. Load long references only when the selected skill requires them.

## Maintenance

Health check:

Windows:

`powershell -NoProfile -ExecutionPolicy Bypass -File {{USER_HOME}}/.orquestrador/doctor.ps1`

Linux/macOS: use the lightest available project validation; `doctor.ps1` is Windows-only unless PowerShell is installed.

Sync skills:

Windows:

`powershell -NoProfile -ExecutionPolicy Bypass -File {{USER_HOME}}/.orquestrador/sync-skills.ps1 -Apply`

Linux/macOS:

`bash {{USER_HOME}}/.orquestrador/sync-skills.sh --apply`
