# Tool Profiles

`tool-profiles/` guarda hooks e perfis textuais selecionados para reaproveitar o comportamento do Orquestrador em outras ferramentas sem publicar o diretório completo de cada uma.

Os hooks e entrypoints estão detalhados em [orquestrador-reference.md](orquestrador-reference.md). Este arquivo explica principalmente quais perfis são empacotados e onde o instalador os coloca.

## Incluído

- `tool-profiles/codex/`: `AGENTS.md` do Codex.
- `tool-profiles/opencode/`: hooks, sistema, regras, maestro e índice de skills.
- `tool-profiles/opencode-global/`: `AGENTS.md` e `opencode.json` globais para `~/.config/opencode`.
- `tool-profiles/claude/`: hooks e prompt de sistema.
- `tool-profiles/cursor/`: hooks.
- `tool-profiles/gemini/`: hooks.
- `tool-profiles/windsurf/`: hooks.
- `tool-profiles/windsurf-global/`: `global_rules.md` para Windsurf/Cascade.
- `tool-profiles/antigravity-home/`: `antigravity-rules.json` instalado no home do usuário.
- `tool-profiles/antigravity/`: `antigravity.json` e `settings.json`.
- `tool-profiles/ai-standards/`: standards portáteis instalados em `~/.ai-standards`.

## Excluído

- OAuth, contas, auth, tokens e configurações MCP locais.
- Histórico de uso, sessões, tracking, browser profile e caches.
- Regras locais de `.codex\rules`, porque podem guardar allowlists e comandos específicos da máquina.
- Diretórios completos de IDE.
- Dados de projetos privados.

## Instalação

O instalador principal já inclui perfis de ferramenta:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Para pular os perfis:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -NoToolProfiles
```

No instalador avançado, perfis de ferramenta são opt-in:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -InstallToolProfiles
```

Se usar o instalador avançado e a máquina já tiver `.orquestrador` ou `AGENTS.md`, use `-Force` para criar backup antes da substituição:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -InstallToolProfiles -Force
```

## Pontos De Entrada Instalados

O pacote instala arquivos nos locais que as ferramentas costumam ler como regra, memória ou configuração global:

| Ferramenta | Arquivo instalado |
|---|---|
| Codex | `%USERPROFILE%\AGENTS.md` e `%USERPROFILE%\.codex\AGENTS.md` |
| OpenCode | `%USERPROFILE%\.config\opencode\AGENTS.md` e `%USERPROFILE%\.config\opencode\opencode.json` |
| Claude Code | `%USERPROFILE%\.claude\CLAUDE.md` |
| Gemini CLI | `%USERPROFILE%\.gemini\GEMINI.md` |
| Cursor | `%USERPROFILE%\.cursor\rules\orquestrador-maestro.mdc` e `%USERPROFILE%\.cursor\AGENTS.md` |
| Windsurf/Cascade | `%USERPROFILE%\.codeium\windsurf\memories\global_rules.md` |
| Antigravity | `%USERPROFILE%\antigravity-rules.json`, `%USERPROFILE%\.antigravity\antigravity.json`, `%USERPROFILE%\.antigravity\settings.json` e `%USERPROFILE%\.ai-standards` |

Todos esses pontos de entrada mandam a ferramenta usar o `AGENTS.md` global, o Orquestrador e, quando existir no projeto aberto, a documentação `DEV/` antes das skills globais. Eles também orientam a manter documentação durável do projeto em `DEV/` e registrar trabalho substancial em `DEV/WORKLOG.md`.

Se uma ferramenta estiver em uma versão que só aceita regra global por UI ou conta em nuvem, copie o conteúdo de `%USERPROFILE%\AGENTS.md` para a regra global dessa ferramenta.
