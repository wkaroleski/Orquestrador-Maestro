# Guia De Instalação

Este guia é para quem baixou o repositório e quer instalar o Orquestrador no próprio usuário do Windows, Linux ou macOS.

## Pré-Requisitos

- Windows com PowerShell ou Linux/macOS com Bash.
- Git instalado para clonar o repositório.
- Codex, Claude, Gemini, Cursor, OpenCode, Windsurf ou Antigravity são opcionais. O instalador prepara as pastas e os arquivos; cada ferramenta continua responsável pelo próprio login, runtime e credenciais.

## Instalação Completa Recomendada

### Windows

```powershell
git clone https://github.com/FernandoBolzan/Orquestrador-Maestro.git
cd Orquestrador-Maestro
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

### Linux/macOS

```bash
git clone https://github.com/FernandoBolzan/Orquestrador-Maestro.git
cd Orquestrador-Maestro
bash install.sh
```

O instalador usa o home do usuário que executa o comando:

```text
Windows: %USERPROFILE%
Linux/macOS: $HOME
```

Em uma máquina de exemplo, se o usuário for `maria`, os destinos ficam abaixo do home dela. Se o usuário for `joao`, ficam abaixo do home dele.

## Pastas Instaladas

| Destino | Função |
|---|---|
| `%USERPROFILE%\.orquestrador` | Núcleo do Orquestrador: regras, maestro, hooks, roteadores, scripts e skills canônicas |
| `%USERPROFILE%\AGENTS.md` | Contrato global lido pelas IAs antes de trabalhar em projetos |
| `%USERPROFILE%\.codex\skills` | Skills disponíveis para Codex |
| `%USERPROFILE%\.codex\agents` | Agentes nativos do Codex |
| `%USERPROFILE%\.codex\prompts` | Prompts dos agentes do Codex |
| `%USERPROFILE%\.agents\skills` | Espelho compatível de skills |
| `%USERPROFILE%\.claude\skills` | Skills para Claude/Claude Code quando aplicável |
| `%USERPROFILE%\.opencode\skills` | Skills para OpenCode |
| `%USERPROFILE%\.cursor\skills` | Skills para Cursor |
| `%USERPROFILE%\.gemini\skills` | Skills para Gemini |
| `%USERPROFILE%\.windsurf\skills` | Skills para Windsurf |
| `%USERPROFILE%\.antigravity-skills\skills` | Espelho adicional de compatibilidade |
| `%USERPROFILE%\.ai-standards` | Standards portáteis usados pelo Antigravity |
| `%USERPROFILE%\.opencode` | Hooks e perfil textual do OpenCode |
| `%USERPROFILE%\.claude` | Hooks e prompt textual do Claude |
| `%USERPROFILE%\.cursor` | Hooks do Cursor |
| `%USERPROFILE%\.gemini` | Hooks do Gemini |
| `%USERPROFILE%\.windsurf` | Hooks do Windsurf |
| `%USERPROFILE%\.config\opencode` | `AGENTS.md` e `opencode.json` globais para OpenCode |
| `%USERPROFILE%\.claude\CLAUDE.md` | Memória global do Claude Code apontando para o Orquestrador |
| `%USERPROFILE%\.cursor\rules\orquestrador-maestro.mdc` | Regra local do Cursor para ativar o Orquestrador |
| `%USERPROFILE%\.gemini\GEMINI.md` | Contexto global do Gemini CLI |
| `%USERPROFILE%\.codeium\windsurf\memories\global_rules.md` | Regras globais do Windsurf/Cascade |
| `%USERPROFILE%\antigravity-rules.json` | Regras globais do Antigravity apontando para Orquestrador e AI standards |
| `%USERPROFILE%\.antigravity\antigravity.json` | Configuração de integração Antigravity + Orquestrador |
| `%USERPROFILE%\.antigravity\settings.json` | Configuração portável do Antigravity |

No Linux/macOS, os destinos equivalentes usam `$HOME` e `/`, por exemplo `$HOME/.orquestrador`, `$HOME/AGENTS.md`, `$HOME/.codex/skills`, `$HOME/.config/opencode` e `$HOME/.ai-standards`.

## Backups

O instalador principal usa backup automático. Quando encontra arquivos ou pastas existentes, ele salva cópias em:

```text
Windows: %USERPROFILE%\.orquestrador-public-backups\YYYYMMDD-HHMMSS
Linux/macOS: $HOME/.orquestrador-public-backups/YYYYMMDD-HHMMSS
```

Depois aplica a instalação completa.

## Verificação

Rode:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-install.ps1
```

No Linux/macOS:

```bash
bash scripts/verify-install.sh
```

Resultado esperado:

```text
Install verification passed.
```

O comando também mostra contagens de skills, agentes e prompts instalados.

## Instalações Alternativas

Só núcleo Orquestrador:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -CoreOnly
```

Linux/macOS:

```bash
bash install.sh --core-only
```

Completo sem hooks/perfis de ferramentas:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -NoToolProfiles
```

Linux/macOS:

```bash
bash install.sh --no-tool-profiles
```

Completo sem forçar substituição de `.orquestrador` e `AGENTS.md` existentes:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -NoForce
```

Linux/macOS:

```bash
bash install.sh --no-force
```

Teste em home temporário:

```powershell
$tempHome = Join-Path $env:TEMP "orquestrador-test-home"
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -HomePath $tempHome
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-install.ps1 -HomePath $tempHome
```

Linux/macOS:

```bash
bash install.sh --home-path /tmp/orquestrador-test-home
bash scripts/verify-install.sh --home-path /tmp/orquestrador-test-home
```

## Depois De Instalar

Abra uma IA ou ferramenta compatível em qualquer projeto e peça:

```text
Leia o AGENTS.md do meu usuário, depois leia o AGENTS.md deste projeto se existir, e a pasta DEV deste projeto se existir.
Use o Orquestrador Maestro, escolha a skill correta e resolva a tarefa com verificação.
```

Quando o projeto tiver `DEV/`, essa pasta é tratada como documentação operacional local. A IA deve começar pelos arquivos de índice ou visão geral (`DEV/AGENTS.md`, `DEV/README.md`, `DEV/INDEX.md`, `DEV/PROJECT.md`, `DEV/CONTEXT.md`) e só depois abrir os documentos específicos da tarefa.

Para criar a estrutura `DEV/` em um projeto:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project-dev.ps1 -ProjectPath "C:\caminho\do\projeto"
```

No Linux/macOS:

```bash
bash scripts/init-project-dev.sh /caminho/do/projeto
```

Depois de instalado, o mesmo helper também fica disponível no usuário:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.orquestrador\bin\init-project-dev.ps1" -ProjectPath "C:\caminho\do\projeto"
```

No Linux/macOS:

```bash
bash "$HOME/.orquestrador/bin/init-project-dev.sh" /caminho/do/projeto
```

O script cria `DEV/README.md`, `DEV/INDEX.md`, `DEV/CONTEXT.md`, `DEV/WORKLOG.md` e subpastas como `ADR/`, `API/`, `DATABASE/`, `RUNBOOKS/`, `TASKS/`, `RESEARCH/`, `HANDOFFS/`, `LOGS/`, `SQL/`, `ARCH/`, `WORKFLOWS/`, `TESTS/`, `DOCUMENTATION/` e `BACKLOG/`, sem sobrescrever arquivos existentes.

O instalador também grava pontos globais de entrada para ferramentas que suportam arquivos de regra ou memória:

- Codex: `%USERPROFILE%\AGENTS.md` e `%USERPROFILE%\.codex\AGENTS.md`.
- OpenCode: `%USERPROFILE%\.config\opencode\AGENTS.md` e `%USERPROFILE%\.config\opencode\opencode.json`.
- Claude Code: `%USERPROFILE%\.claude\CLAUDE.md`.
- Gemini CLI: `%USERPROFILE%\.gemini\GEMINI.md`.
- Cursor: `%USERPROFILE%\.cursor\rules\orquestrador-maestro.mdc` e `%USERPROFILE%\.cursor\AGENTS.md`.
- Windsurf/Cascade: `%USERPROFILE%\.codeium\windsurf\memories\global_rules.md`.
- Antigravity: `%USERPROFILE%\antigravity-rules.json`, `%USERPROFILE%\.antigravity\antigravity.json`, `%USERPROFILE%\.antigravity\settings.json` e `%USERPROFILE%\.ai-standards`.

No Linux/macOS, esses pontos usam `$HOME`, como `$HOME/AGENTS.md`, `$HOME/.config/opencode/opencode.json`, `$HOME/.claude/CLAUDE.md`, `$HOME/.cursor/AGENTS.md`, `$HOME/.gemini/GEMINI.md`, `$HOME/.codeium/windsurf/memories/global_rules.md` e `$HOME/.ai-standards`.

Se uma versão da ferramenta usar regras globais em nuvem ou apenas pela interface, copie o conteúdo de `%USERPROFILE%\AGENTS.md` no Windows ou `$HOME/AGENTS.md` no Linux/macOS para a regra global do usuário nessa interface.

## Troubleshooting

Se o PowerShell bloquear execução de script, use sempre:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Se a instalação parecer incompleta, rode:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-install.ps1
```

No Linux/macOS:

```bash
bash scripts/verify-install.sh
```

Se quiser voltar uma instalação anterior, procure o backup mais recente em:

```text
Windows: %USERPROFILE%\.orquestrador-public-backups
Linux/macOS: $HOME/.orquestrador-public-backups
```

Este repo não instala credenciais, tokens, logins ou chaves de API. Configure esses itens diretamente em cada ferramenta.
