# Referência Técnica Do Orquestrador

Este documento explica a lógica interna do Orquestrador Maestro: como ele escolhe skills, como os hooks funcionam, quais arquivos controlam o comportamento e como uma IA deve usar o pacote depois da instalação.

Para a lista completa de skills publicadas, use também [skill-catalog.md](skill-catalog.md).
Para a estratégia de economia de contexto, use [context-economy.md](context-economy.md).

## Ideia Central

O Orquestrador não é uma ferramenta única. Ele é uma camada de regras, roteamento e memória que prepara várias IAs para trabalhar do mesmo jeito no computador do usuário.

O fluxo esperado é:

1. Ler as regras globais do usuário.
2. Ler as regras do projeto atual.
3. Ler a documentação operacional `DEV/` do projeto, quando existir.
4. Escolher a skill mínima que resolve a tarefa.
5. Executar com o menor contexto suficiente.
6. Verificar antes de concluir.
7. Atualizar `DEV/WORKLOG.md` quando houver trabalho substancial.

## Fontes De Verdade

| Arquivo | Função |
|---|---|
| `orquestrador/rules.md` | Contrato global: hierarquia, qualidade, segurança, `DEV/`, verificação e sync. |
| `orquestrador/maestro.md` | Protocolo de execução: observar, rotear, selecionar, agir, verificar e reportar. |
| `orquestrador/hooks.md` | Roteador compacto dos hooks de preflight, verificação, sync, skills e orçamento de tokens. |
| `orquestrador/SKILLS_INDEX.md` | Índice curto para encontrar o roteador certo sem carregar catálogo completo. |
| `orquestrador/SKILL_ALIASES.json` | Mapeia termos do usuário para uma skill canônica. |
| `orquestrador/SKILLS_ROUTER.json` | Catálogo operacional das skills canônicas, com gatilhos, caminhos, custo e segurança. |
| `orquestrador/SKILL_CHAINS.json` | Define quais skills podem ser combinadas depois que uma skill principal é escolhida. |
| `orquestrador/SKILL_EXECUTION_PROFILES.json` | Define perfis `fast`, `standard`, `deep`, `multiagent`, `saas` e `security`. |
| `orquestrador/SKILL_USAGE_SCHEMA.json` | Esquema para logar uso de skills em JSONL quando a ferramenta suportar. |
| `orquestrador/PROGRAM_ENTRYPOINTS.json` | Mapa dos arquivos que cada ferramenta deve ler no home do usuário. |
| `orquestrador/PROJECT_DEV_HIERARCHY.md` | Convenção da pasta `DEV/` em projetos. |

## Lógica De Roteamento

O roteamento foi desenhado para economizar tokens. A IA não deve abrir todas as skills para decidir o que fazer.

1. Identifica o tipo de tarefa pelo pedido do usuário e pelo projeto atual.
2. Escolhe um perfil em `SKILL_EXECUTION_PROFILES.json`.
3. Procura termos em `SKILL_ALIASES.json`.
4. Confirma a skill principal em `SKILLS_ROUTER.json`.
5. Se a tarefa pedir mais de uma frente, consulta `SKILL_CHAINS.json`.
6. Abre só o `SKILL.md` da skill escolhida e, se necessário, referências diretas dessa skill.
7. Executa a tarefa e valida de acordo com o perfil.

Exemplo: um pedido como "criar SaaS com Stripe e dashboard" cai em `skill-saas-factory`. A cadeia permite chamar `skill-stripe-integration`, `skill-saas-admin-dashboard`, `skill-saas-core-limits` e skills de segurança se a evidência da tarefa justificar.

## Perfis De Execução

| Perfil | Quando usar | Limite de skills | Delegação | Validação |
|---|---|---:|---|---|
| `fast` | Resposta curta, ajuste pequeno ou tarefa óbvia. | 1 | Não | Verificação mínima útil. |
| `standard` | Caminho padrão para a maioria das tarefas. | 3 | Não | Validação proporcional à mudança. |
| `deep` | Mudança ampla, multi-sistema ou risco maior. | 5 | Sim | Lint, typecheck, teste, build ou doctor. |
| `multiagent` | Usuário pede agentes, time, swarm ou paralelismo. | 5 | Sim | Integração mais verificação por frente. |
| `saas` | Produto SaaS, dashboard, pagamento, tenancy ou admin. | 5 | Sim | Gates do projeto mais segurança. |
| `security` | Scan ou auditoria defensiva autorizada. | 4 | Sim | Gates de segurança. Exige autorização explícita. |

## Hooks

No repositório, "hook" significa uma regra operacional que dispara antes, durante ou depois do trabalho. Alguns hooks são documentos de orientação para a IA; outros são scripts instaláveis de Git.

| Hook | Onde fica | O que faz |
|---|---|---|
| Preflight hook | `orquestrador/hooks.md` | Antes de trabalho amplo, manda ler `AGENTS.md`, perfis, aliases, router e só depois escolher skills. |
| Automatic skill hook | `orquestrador/hooks.md` e hooks de ferramentas | Mapeia gatilhos como SaaS, Stripe, RLS, DAST, UX ou analytics para skills específicas. |
| Token budget hook | `orquestrador/hooks.md` | Impede carregar catálogos completos; limita skills por perfil. |
| Verification hook | `orquestrador/hooks.md` | Obriga verificação antes de dizer que terminou; para config global recomenda `doctor.ps1`. |
| Sync hook | `orquestrador/hooks.md` | Depois de mudar uma skill compartilhada, manda rodar `sync-skills.ps1 -Apply` no Windows ou `sync-skills.sh --apply` no Linux/macOS. |
| Usage log hook | `SKILL_USAGE_SCHEMA.json` | Define um log JSONL opcional para medir quais skills foram selecionadas e abertas. |
| Project DEV hook | `PROJECT_DEV_HIERARCHY.md` | Pede leitura compacta de `DEV/` e atualização de `DEV/WORKLOG.md` após trabalho substancial. |
| Tool entrypoint hook | `PROGRAM_ENTRYPOINTS.json` e `tool-profiles/` | Faz Codex, OpenCode, Claude, Cursor, Gemini, Windsurf e Antigravity chamarem o Orquestrador por padrão. |
| Security Git hooks | `skill-security-hooks/scripts/install-security-hooks.cmd` | Instala `.githooks/pre-commit` e `.githooks/pre-push` em repositório autorizado. |

## Hooks De Segurança Instaláveis

A skill `skill-security-hooks` tem um script real para instalar hooks Git defensivos:

```powershell
%USERPROFILE%\.orquestrador\skills\skill-security-hooks\scripts\install-security-hooks.cmd "C:\caminho\repo" --authorized-local-repo
```

O script exige a flag `--authorized-local-repo`, verifica se existe `.git`, cria `.githooks` e recusa sobrescrever hooks existentes. Ele só aponta `core.hooksPath` para `.githooks` se não houver outro caminho de hooks diferente já configurado.

| Hook Git | Lógica |
|---|---|
| `pre-commit` | Se `gitleaks` estiver instalado, roda `gitleaks protect --staged --redact`; se não estiver, avisa e não bloqueia. |
| `pre-push` | Chama `skill-saas-security-scan/scripts/saas-security-scan.cmd` com autorização local. |

O scan local cria `security-reports/` no repositório alvo e tenta usar ferramentas já instaladas:

| Ferramenta | Uso |
|---|---|
| Gitleaks | Secret scan com redaction. |
| Semgrep | SAST com OWASP Top 10 e secrets. |
| OSV-Scanner | Dependências vulneráveis. |
| Trivy | Vulnerabilidades, secrets e misconfig em filesystem. |
| npm audit | Dependências Node quando existe `package-lock.json`. |

O DAST autorizado fica separado em `skill-saas-dast-recon/scripts/saas-dast-recon.cmd`. Ele exige URL `http://` ou `https://` e flag `--i-own-this-target`, usa rate limit conservador e só roda ZAP se `ZAP_DOCKER_IMAGE` estiver explicitamente configurado.

## Skills Canônicas

Estas são as skills principais mantidas em `orquestrador/skills/`. Elas são copiadas para os espelhos de ferramentas pelo sync.

| Skill | Lógica principal |
|---|---|
| `skill-saas-factory` | Skill guarda-chuva para construir, revisar ou planejar SaaS. Roteia para dashboard, pagamentos, RLS, limites, segurança, analytics e orquestração quando necessário. |
| `skill-saas-admin-dashboard` | Define padrões de painel admin: usuários, tenants, planos, pagamentos, logs, métricas, filtros, tabelas, suporte e onboarding. |
| `skill-abacatepay-integration` | Guia pagamento brasileiro com PIX/cartão, CPF/CNPJ, webhooks, recibos, cancelamento, reembolso e sincronização de entitlement. |
| `skill-stripe-integration` | Guia Checkout, Billing, subscriptions, portal, invoices, trials, coupons, webhooks e estado de assinatura. |
| `skill-saas-core-limits` | Implementa limites de plano, cotas, entitlements, trials, grace period, bloqueios e contadores de uso. |
| `skill-supabase-rls` | Modela e revisa RLS, isolamento de tenant, policies, storage, service role, índices e testes positivo/negativo. |
| `skill-saas-security-scan` | Orquestra scans defensivos locais em repositórios autorizados com Semgrep, Gitleaks, Trivy, OSV e npm audit. |
| `skill-saas-dast-recon` | Orquestra DAST/recon conservador em alvo próprio ou autorizado, com Nuclei, Katana e ZAP baseline opcional. |
| `skill-security-hooks` | Instala e mantém hooks Git e gates de CI defensivos sem sobrescrever configuração existente. |
| `skill-ai-orchestration` | Estrutura uso server-side de provedores de IA, roteamento de modelos, orçamento de tokens, fallback, filas, retries e observabilidade. |
| `skill-multiagent-orchestration` | Divide trabalho independente entre agentes, define posse por arquivos/módulos e mantém integração final com o agente líder. |
| `skill-aionui-cowork-orchestration` | Integra AionUi como camada de coordenação sem substituir Codex, skills, hooks, MCPs e permissões locais. |
| `skill-evolution-api` | Guia automação WhatsApp com Evolution API: instancias, QR, webhooks, consentimento, filas, idempotência e rate limits. |
| `skill-frontend-ux-guardrails` | Aplica gates de UX: responsividade, overflow, acessibilidade, consistência visual, spelling e validação em telas. |
| `skill-modern-ui-patterns` | Orienta composição de UI SaaS/admin com React, TypeScript, Tailwind, estados de componentes e design system. |
| `skill-open-design-ui` | Guia redesign visual, tokens, biblioteca de componentes e QA visual sem cair em layout genérico. |
| `skill-live-processing` | Desenha pipeline de live/VOD: captura, filas, transcrição, clips, storage, retries, workers e observabilidade. |
| `skill-manual-video-processing` | Guia upload manual de vídeo/áudio com validação, malware scan, cotas, jobs assíncronos, transcrição e signed URLs. |
| `skill-smart-clip-detection` | Detecta candidatos de clips por transcript/mídia, score, timestamps, batches, revisão e metadados publicáveis. |
| `skill-unified-analytics` | Define taxonomia de eventos, métricas, funis, dashboards, privacidade, ativação, retenção e billing metrics. |
| `skill-elevenlabs-voice-cloning` | Integra TTS/clonagem ElevenLabs com consentimento explícito, uploads seguros, jobs e proteção de biometria vocal. |
| `skill-google-workspace-sync` | Guia OAuth, Calendar, Meet, Drive, Sheets, webhooks, escopos mínimos, refresh tokens e reconciliação. |

## Skills Workflow Do Codex/OMX

Além das skills canônicas, `codex/skills/` inclui workflows operacionais:

| Skill | O que faz |
|---|---|
| `orquestrador-maestro` | Entrada Codex para aplicar o contrato Orquestrador/Maestro. |
| `plan` | Planejamento estruturado antes de executar. |
| `ralplan` | Atalho para planejamento com consenso. |
| `ralph` | Loop persistente até terminar com verificação de arquiteto. |
| `team` | Coordena múltiplos agentes com lista compartilhada de tarefas. |
| `ultrawork` | Execução paralela de alta vazão. |
| `worker` | Protocolo de worker para tarefas delegadas. |
| `autopilot` | Execução autônoma ampla, da ideia ao código funcionando. |
| `deep-interview` | Entrevista estruturada quando o escopo está ambíguo. |
| `code-review` | Revisão focada em bugs, riscos e regressões. |
| `security-review` | Revisão de segurança, trust boundaries, auth e exposição de dados. |
| `web-clone` | Clonagem/reprodução de página com verificação visual e funcional. |
| `visual-verdict` | Veredito de QA visual a partir de screenshot/referência. |
| `doctor` | Diagnóstico e reparo de instalação OMX/Codex. |
| `omx-setup` | Setup/configuração do oh-my-codex. |
| `skill` | Gerenciamento local de skills. |
| `ask-claude` | Consulta Claude CLI e registra artefato reutilizável. |
| `ask-gemini` | Consulta Gemini CLI e registra artefato reutilizável. |
| `note` | Salva notas para resistir a compactação de contexto. |
| `hud` | Exibe/configura statusline OMX. |
| `trace` | Mostra timeline e resumo do fluxo de agentes. |
| `cancel` | Cancela modos ativos OMX. |
| `configure-notifications` | Configura notificações OMX. |
| `help` | Ajuda de uso do pacote. |
| `ai-slop-cleaner` | Limpa/refatora saída excessivamente genérica ou mal acabada. |

## Agentes Codex

Os agentes em `codex/agents/` são perfis de delegação. Eles não substituem o Orquestrador; são usados quando a tarefa justifica paralelismo ou especialização.

| Agente | Responsabilidade |
|---|---|
| `analyst` | Clareza de requisitos, critérios de aceite e restrições ocultas. |
| `architect` | Design de sistema, limites, interfaces e tradeoffs longos. |
| `build-fixer` | Falhas de build, toolchain e tipos. |
| `code-reviewer` | Revisão ampla de qualidade, regressões e riscos. |
| `code-simplifier` | Simplifica código modificado sem mudar comportamento. |
| `critic` | Desafia plano/design e encontra riscos. |
| `debugger` | Diagnóstico de causa raiz e regressões. |
| `dependency-expert` | Avaliação de SDKs, APIs e pacotes externos. |
| `designer` | Arquitetura UX/UI e interação. |
| `executor` | Implementação, refatoração e feature work. |
| `explore` | Busca rápida no codebase e mapeamento de símbolos. |
| `git-master` | Estratégia de commit, histórico e rebase. |
| `planner` | Sequenciamento, plano e riscos. |
| `researcher` | Pesquisa externa e documentação de referência. |
| `security-reviewer` | Vulnerabilidades, authn/authz e trust boundaries. |
| `team-executor` | Execução coordenada conservadora. |
| `test-engineer` | Estratégia de teste, cobertura e flakiness. |
| `verifier` | Evidência de conclusão e adequação de testes. |
| `vision` | Análise de imagem, screenshot e diagrama. |
| `writer` | Documentação, notas de migração e orientação ao usuário. |

## Instalação E Sync

O `install.ps1` da raiz é um wrapper conservador para Windows. Por padrão ele chama `scripts/install.ps1` com `-Force` e instala perfis de ferramentas, a menos que o usuário passe `-NoForce`, `-NoToolProfiles` ou `-CoreOnly`.

O `install.sh` da raiz é o wrapper equivalente para Linux/macOS. Por padrão ele chama `scripts/install.sh` com `--force` e instala perfis de ferramentas, a menos que o usuário passe `--no-force`, `--no-tool-profiles` ou `--core-only`.

Os wrappers também aceitam prévia e manutenção segura:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -DryRun
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -ListTargets
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Only codex
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Uninstall -DryRun
```

Linux/macOS:

```bash
bash install.sh --dry-run
bash install.sh --list-targets
bash install.sh --only codex
bash install.sh --uninstall --dry-run
```

Por padrão, `DryRun` e `ListTargets` mostram IDs simbólicos. Paths completos ficam restritos a `-VerbosePaths` ou `--verbose-paths`.

Os motores `scripts/install.ps1` e `scripts/install.sh`:

1. Resolve o home do usuário atual.
2. Monta fontes do repo: `orquestrador/`, `home/AGENTS.md`, `codex/`, `skill-library/community-skills/` e `tool-profiles/`.
3. Faz backup em `%USERPROFILE%\.orquestrador-public-backups` no Windows ou `$HOME/.orquestrador-public-backups` no Linux/macOS quando substitui algo.
4. Copia arquivos textuais trocando `{{USER_HOME}}`, `{{USER_NAME}}` e `{{USER_FULL_NAME}}`.
5. Instala skills e perfis conforme flags.
6. Cria `.orquestrador/logs` no home do usuário.
7. Roda `sync-skills.ps1 -Apply` no Windows ou `sync-skills.sh --apply` no Linux/macOS, salvo quando o sync é desativado.

O `sync-skills.ps1` e o `sync-skills.sh` mantêm as 22 skills canônicas nos espelhos:

```text
.codex\skills
.opencode\skills
.agents\skills
.claude\skills
.cursor\skills
.gemini\skills
.windsurf\skills
.antigravity-skills\skills
.ai-standards
```

Ele compara arquivos por SHA256, copia quando falta ou quando difere, e só remove destino calculado dentro da raiz esperada.

## Verificação

Use `scripts/verify-install.ps1` depois de instalar. Ele verifica:

- `rules.md`, `maestro.md`, `PROJECT_DEV_HIERARCHY.md`, `SKILLS_INDEX.md`, `SKILLS_ROUTER.json` e skills canônicas.
- `%USERPROFILE%\AGENTS.md`.
- Skills, agentes e prompts do Codex.
- Espelhos `.agents`, `.claude`, `.opencode`, `.cursor`, `.gemini`, `.windsurf` e `.antigravity-skills`.
- Entry points Antigravity: `antigravity-rules.json`, `.antigravity/antigravity.json`, `.antigravity/settings.json` e `.ai-standards`.
- Entrypoints de ferramentas quando os perfis não foram pulados.
- Presença de `DEV/WORKLOG.md` nas regras globais e perfis principais.
- Configuração OpenCode com `~/.orquestrador/rules.md` e `~/.orquestrador/maestro.md`.

Use `scripts/validate-public.ps1` antes de publicar. Ele valida JSON, paths proibidos, diretórios locais, arquivos de log/backup, padrões prováveis de segredo, caminhos concretos de usuário e mojibake.

## Biblioteca Comunitária

`skill-library/community-skills/` contém uma biblioteca deduplicada grande. Ela é instalada como compatibilidade para ferramentas que procuram skills em raízes diferentes. O Orquestrador não deve carregar essa biblioteca inteira em tarefas normais.

Uso esperado:

1. Roteador canônico primeiro.
2. Skill canônica ou workflow Codex quando houver correspondência.
3. Biblioteca comunitária só quando a tarefa pedir uma tecnologia ou domínio que não exista nas 22 skills canônicas.
4. Abrir apenas a pasta da skill escolhida.

O catálogo completo publicado está em [skill-catalog.md](skill-catalog.md).
