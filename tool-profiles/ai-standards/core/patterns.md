# Implementation Patterns

Use these defaults unless the project has a stricter local pattern:

- Read project conventions before creating new structure.
- Prefer existing helpers and framework patterns.
- Keep changes scoped to the task.
- Use structured parsers for structured data.
- Add tests when behavior changes.
- Run lint, typecheck, tests or build when available and meaningful.
- Keep durable project notes in `DEV/`.
- Keep `DEV/WORKLOG.md` compact so the next session can recover context cheaply.

For frontend work:

- preserve existing design conventions;
- verify responsive behavior;
- avoid overlapping text and controls;
- use real app screens rather than landing-page filler.

For security-sensitive work:

- require authorized scope;
- redact secrets;
- avoid publishing local runtime files;
- summarize residual risk clearly.
