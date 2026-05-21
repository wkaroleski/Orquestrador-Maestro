# Pacotes De Skills

Este repositório publica o máximo prático de conteúdo textual reutilizável sem virar dump do home do usuário.

## Pacotes

| Pacote | Fonte local | Destino no repo | Conteúdo |
|---|---|---|---|
| Orquestrador | `~/.orquestrador` | `orquestrador/` | Regras, hooks, roteadores, índices, scripts e skills canônicas |
| Codex | `~/.codex/skills`, `~/.codex/agents`, `~/.codex/prompts` | `codex/` | Skills workflow OMX/Codex, agentes nativos e prompts |
| Community Skills | `~/.agents/skills` | `skill-library/community-skills/` | Biblioteca deduplicada que representa os espelhos `.agents/.claude/.opencode/.cursor/.gemini/.windsurf` |
| Tool Profiles | perfis textuais selecionados | `tool-profiles/` | Hooks, regras e prompts globais reaproveitáveis de ferramentas |

Para ver o que cada skill publicada faz, consulte [skill-catalog.md](skill-catalog.md). Para entender como essas skills são escolhidas e combinadas, consulte [orquestrador-reference.md](orquestrador-reference.md).

## Por Que Não Copiar Cada Raiz Inteira

As raízes `.agents`, `.claude`, `.opencode`, `.cursor`, `.gemini`, `.windsurf` e `.antigravity-skills` têm muita duplicação. O repo guarda uma biblioteca deduplicada e o instalador copia essa biblioteca para os destinos compatíveis.

Perfis como `.claude`, `.cursor`, `.gemini` e `.opencode` também costumam conter histórico, estado local, OAuth, configurações de IDE e dados de projetos. Por isso o pacote `tool-profiles/` é uma seleção controlada de arquivos textuais.

## Exclusões

O sync remove ou pula:

- `node_modules`, builds, dist, coverage e caches.
- logs, backups, relatórios locais, memórias e `.bak`.
- `.env`, `config.toml` e configurações locais.
- caminhos privados, nomes privados e valores com cara de segredo.
- caches Python e binários temporários.

## Instalação

Instalação completa recomendada, incluindo núcleo, skills, agentes, prompts e perfis de ferramenta:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Linux/macOS:

```bash
bash install.sh
```

Instalação avançada de núcleo, skills, agentes e prompts sem os perfis de ferramenta:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

Linux/macOS:

```bash
bash scripts/install.sh --force
```

Instalação avançada incluindo hooks/perfis de ferramenta:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -InstallToolProfiles
```

Linux/macOS:

```bash
bash scripts/install.sh --force --install-tool-profiles
```

Só núcleo Orquestrador:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -SkipExtraSkills
```

Linux/macOS:

```bash
bash scripts/install.sh --force --skip-extra-skills
```

Codex pack sem biblioteca comunitária:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -SkipCommunitySkills
```

Linux/macOS:

```bash
bash scripts/install.sh --force --skip-community-skills
```

Em máquinas que já têm essas pastas, use `-Force` no PowerShell ou `--force` no Bash para fazer backup e mesclar a instalação.
