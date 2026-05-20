# OpenCode Hooks

This file is a compact hook router. It is not a full skill catalog.

## Required Preflight

1. Identify task type.
2. Read `{{USER_HOME}}/.orquestrador\SKILL_EXECUTION_PROFILES.json`.
3. Read `{{USER_HOME}}/.orquestrador\SKILL_ALIASES.json`.
4. Read `{{USER_HOME}}/.orquestrador\SKILLS_ROUTER.json`.
5. Use `{{USER_HOME}}/.orquestrador\SKILL_CHAINS.json` only after choosing the primary skill.
6. Load only the selected `SKILL.md` files.
7. Run the lightest meaningful verification.

## Automatic Skill Hooks

| Trigger | Skill |
|---|---|
| Build, review, or plan SaaS product/dashboard/payments | `/skill:skill-saas-factory` |
| SaaS admin panel, users, plans, payments, logs, metrics | `/skill:skill-saas-admin-dashboard` |
| AbacatePay, PIX, CPF/CNPJ, BRL billing | `/skill:skill-abacatepay-integration` |
| Stripe Checkout, Billing, subscriptions, portal | `/skill:skill-stripe-integration` |
| Plan limits, quotas, trials, grace, entitlements | `/skill:skill-saas-core-limits` |
| Local repository security scan | `/skill:skill-saas-security-scan` |
| Authorized staging or preview DAST/recon | `/skill:skill-saas-dast-recon` |
| Git hooks or CI security gates | `/skill:skill-security-hooks` |
| Supabase, RLS, tenant isolation, policies | `/skill:skill-supabase-rls` |
| AI routing, model fallback, token budget, agent gateway | `/skill:skill-ai-orchestration` |
| Subagents, multiagents, swarm, team execution, delegation | `/skill:skill-multiagent-orchestration` |
| AionUi, cowork app, Team Mode, unified MCP/agent UI | `/skill:skill-aionui-cowork-orchestration` |
| WhatsApp, Evolution API, message webhooks | `/skill:skill-evolution-api` |
| Frontend polish, responsive guardrails, layout QA | `/skill:skill-frontend-ux-guardrails` |
| SaaS UI system or admin component patterns | `/skill:skill-modern-ui-patterns` |
| Open-design visual upgrade or design tokens | `/skill:skill-open-design-ui` |
| Live video/audio processing pipeline | `/skill:skill-live-processing` |
| Manual video upload and processing | `/skill:skill-manual-video-processing` |
| Smart clips, highlights, video moment detection | `/skill:skill-smart-clip-detection` |
| Product analytics, events, funnels, KPIs | `/skill:skill-unified-analytics` |
| ElevenLabs, TTS, voice cloning | `/skill:skill-elevenlabs-voice-cloning` |
| Google Workspace, Calendar, Meet, FreeBusy, OAuth sync | `/skill:skill-google-workspace-sync` |

## Token Budget Rule

Do not load all skills to decide what to do. Read aliases, profiles, and router first. In `fast`, load one skill. In `standard`, load at most three skills. In `deep`, `saas`, or `security`, load more only when `SKILL_CHAINS.json` says the chain is allowed.

## Usage Log

When supported, append one JSON line after broad work using:

`{{USER_HOME}}/.orquestrador\SKILL_USAGE_SCHEMA.json`

## Health Hook

Use this command before broad configuration changes:

`powershell -NoProfile -ExecutionPolicy Bypass -File {{USER_HOME}}/.orquestrador\doctor.ps1`
