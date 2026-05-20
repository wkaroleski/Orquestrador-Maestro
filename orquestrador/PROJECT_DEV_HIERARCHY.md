# Project DEV Hierarchy

`DEV/` is the canonical project documentation and memory root.

Use it to reduce token use across sessions: read compact indexes first, then load only the task-relevant detail files.

## Required Files

Every project that uses this convention should keep:

- `DEV/README.md`: short project documentation entrypoint.
- `DEV/INDEX.md`: map of available project docs and what each file is for.
- `DEV/CONTEXT.md`: current project state, constraints, assumptions, commands, and open risks.
- `DEV/WORKLOG.md`: compact chronological hook of substantive work done by agents.

## Recommended Sub-Hierarchy

Use these paths when relevant:

- `DEV/ARCHITECTURE.md`
- `DEV/DECISIONS.md`
- `DEV/ADR/`
- `DEV/API/`
- `DEV/DATABASE/`
- `DEV/TESTING.md`
- `DEV/RUNBOOKS/`
- `DEV/TASKS/`
- `DEV/ROADMAP.md`
- `DEV/RESEARCH/`
- `DEV/HANDOFFS/`

## Compatible Existing Sub-Hierarchies

Many projects already use a richer DEV tree. Treat these as first-class compatible paths:

- `DEV/LOGS/`
- `DEV/SQL/`
- `DEV/ARCH/`
- `DEV/WORKFLOWS/`
- `DEV/TESTS/`
- `DEV/DOCUMENTATION/`
- `DEV/BACKLOG/`

Do not rename or move existing DEV docs just to match the recommended names. Add or update `DEV/INDEX.md` so agents can map the current project layout quickly.

## Read Order

When entering a project:

1. Read the nearest project `AGENTS.md`, when present.
2. Read `DEV/README.md` or `DEV/INDEX.md`.
3. Read `DEV/CONTEXT.md`.
4. Open only the detail files relevant to the task.
5. Select global skills after project context is understood.

Do not bulk-load the full `DEV/` tree by default.

## Write Hook

After any substantive project work, update `DEV/WORKLOG.md`.

Each entry should be compact:

```text
## YYYY-MM-DD - Short task title

- Changed: paths or areas touched.
- Why: one sentence.
- Verified: command or manual check.
- Next context: only what the next agent needs.
```

Also update:

- `DEV/INDEX.md` when a DEV doc is created, renamed, or removed.
- `DEV/CONTEXT.md` when project assumptions, commands, architecture, environment, or risks change.
- The relevant detail file when a durable decision or project fact changes.

If the project has `DEV/LOGS/`, keep long execution logs there and place only the compact next-session summary in `DEV/WORKLOG.md`.

## Documentation Placement

Create durable project documentation under `DEV/` by default.

If the user asks for a public-facing file outside `DEV/`, such as root `README.md` or product docs, keep the operational context, decision, and maintenance note in `DEV/` as well.

Do not paste long logs, full diffs, dependency dumps, or generated output into `DEV/`. Link to paths and summarize the result.
