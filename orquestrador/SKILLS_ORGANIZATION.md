# Skills Organization

Use this as the operating model for shared local skills.

## Principles

- `{{USER_HOME}}/.orquestrador\skills` is the canonical source for custom skills.
- `{{USER_HOME}}/.orquestrador\SKILLS_ROUTER.json` is the first file agents should read.
- `{{USER_HOME}}/.orquestrador\SKILL_ALIASES.json` maps user wording to canonical skill names.
- `{{USER_HOME}}/.orquestrador\SKILL_CHAINS.json` controls which skills may be chained together.
- `{{USER_HOME}}/.orquestrador\SKILL_EXECUTION_PROFILES.json` controls max skill loading and validation depth.
- Agent roots such as `.codex`, `.claude`, `.opencode`, `.agents`, `.cursor`, `.gemini`, `.windsurf`, and `.antigravity-skills` are mirrors.
- Do not edit mirrors by hand unless debugging; edit canonical skills and run sync.
- Keep skill bodies concise. Put heavy details under `references/` only when needed.

## Categories

| Category | Purpose |
|---|---|
| `saas` | SaaS construction, limits, dashboards, payments, tenant workflows |
| `payments` | Provider-specific billing, checkout, webhook and entitlement sync |
| `security` | RLS, scans, hooks, DAST, secrets, dependency checks |
| `frontend` | UI systems, admin dashboards, UX guardrails, design patterns |
| `ai` | OpenAI/Gemini/audio/image orchestration and cost controls |
| `orchestration` | Multiagent routing, AionUi cowork, delegation, ownership, integration, and token control |
| `communication` | WhatsApp, webhooks, messaging automation |
| `media` | Live ingestion, uploads, clipping, video/audio processing |
| `analytics` | Events, funnels, dashboards, attribution, metric contracts |
| `integrations` | External systems such as Google Workspace |

## Skill Quality Bar

Every custom skill should have:

- YAML frontmatter with `name`, `description`, `category`, `risk`, and `source`.
- A strong `description` that says when to use the skill.
- A compact workflow that starts with the minimum safe action.
- Guardrails for secrets, destructive operations, privacy, billing, and production systems when relevant.
- Verification steps that fit the risk level.
- Related skills as plain names when they should be chained.
- No TODO, stub, placeholder, or broken UTF-8 text.
- No known stale API examples when provider docs have changed.
- Source notes when the skill depends on a fast-moving ecosystem or security tool.

## Automatic Invocation Contract

Agents should treat `SKILLS_ROUTER.json` as the automatic invocation layer:

1. Read the user request and project context.
2. Choose an execution profile.
3. Match aliases and router triggers before loading any full skill body.
4. Start from one top-level skill when possible, especially `skill-saas-factory`.
5. Chain provider-specific skills only when the task touches that provider and `SKILL_CHAINS.json` allows it.
6. Use `skill-multiagent-orchestration` when the user asks for subagents/multiagents or when independent lanes clearly reduce time or risk.
7. Use `skill-aionui-cowork-orchestration` when AionUi, cowork agents, Team Mode, or unified MCP/agent UI is in scope.
8. Prefer local repository evidence over broad catalog loading.
9. Append a usage log entry when the tool supports it.
10. Run `doctor.ps1` after global skill or hook changes.

## Current External Baselines

Refresh security and SaaS skills against primary sources:

- OWASP ASVS 5.x for application security verification.
- OWASP Cheat Sheet Series for focused implementation guidance.
- Supabase RLS docs for browser-safe database access and policy behavior.
- Stripe and AbacatePay docs for payment/webhook behavior.
- Semgrep rules/registry, Gitleaks, Trivy, ZAP, Nuclei, and nuclei-templates for scanning workflows.

## Improvement Workflow

1. Edit canonical skill in `.orquestrador\skills`.
2. Update `SKILLS_ROUTER.json` if the triggers changed.
3. Add the skill to `$mustHave` in `sync-skills.ps1` only if it should be mirrored everywhere.
4. Run:

`powershell -NoProfile -ExecutionPolicy Bypass -File {{USER_HOME}}/.orquestrador\sync-skills.ps1 -Apply`

5. Run:

`powershell -NoProfile -ExecutionPolicy Bypass -File {{USER_HOME}}/.orquestrador\doctor.ps1`
