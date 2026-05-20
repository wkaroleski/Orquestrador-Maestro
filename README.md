# Orquestrador Maestro

Kit público para instalar um ambiente de Orquestrador, skills, hooks e perfis de IA no usuário atual do Windows.

A ideia é simples: a pessoa baixa este repositório, executa o instalador e recebe a mesma estrutura base do Orquestrador no próprio `%USERPROFILE%`, com os caminhos ajustados para o usuário dela.

## Instalação Rápida

Abra o PowerShell e rode:

```powershell
git clone https://github.com/FernandoBolzan/Orquestrador-Maestro.git
cd Orquestrador-Maestro
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Esse comando instala o pacote completo no usuário atual:

- `%USERPROFILE%\.orquestrador`
- `%USERPROFILE%\AGENTS.md`
- `%USERPROFILE%\.codex\skills`
- `%USERPROFILE%\.codex\agents`
- `%USERPROFILE%\.codex\prompts`
- `%USERPROFILE%\.agents\skills`
- `%USERPROFILE%\.claude\skills`
- `%USERPROFILE%\.opencode\skills`
- `%USERPROFILE%\.cursor\skills`
- `%USERPROFILE%\.gemini\skills`
- `%USERPROFILE%\.windsurf\skills`
- `%USERPROFILE%\.antigravity-skills\skills`
- hooks e perfis textuais em `.codex`, `.opencode`, `.claude`, `.cursor`, `.gemini` e `.windsurf`
- pontos globais de entrada para as ferramentas: `.config\opencode\AGENTS.md`, `.config\opencode\opencode.json`, `.claude\CLAUDE.md`, `.gemini\GEMINI.md`, `.cursor\rules\orquestrador-maestro.mdc` e `.codeium\windsurf\memories\global_rules.md`

Se algum desses destinos já existir, o instalador cria backup em:

```text
%USERPROFILE%\.orquestrador-public-backups
```

## Verificar Instalação

Depois de instalar:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-install.ps1
```

Se a verificação passar, as IAs já podem usar o Orquestrador pelos arquivos globais instalados no home do usuário. O `AGENTS.md` global continua sendo o contrato comum; os perfis de OpenCode, Claude, Gemini, Cursor e Windsurf apontam para ele e para `.orquestrador`.

## Como Pedir Para Uma IA Usar

Depois da instalação, em qualquer projeto, peça para a IA seguir o contrato global:

```text
Leia primeiro o AGENTS.md do meu usuário, depois use o Orquestrador Maestro.
Siga a hierarquia de regras, leia a pasta DEV do projeto se existir, consulte as skills disponíveis e resolva a tarefa com verificação.
```

O comportamento esperado está documentado em [docs/ai-agent-operating-guide.md](docs/ai-agent-operating-guide.md).

Guia completo com link de download, instalação, verificação e uso: [docs/orquestrador.md](docs/orquestrador.md).

Referência técnica com lógica de skills, hooks, perfis e roteamento: [docs/orquestrador-reference.md](docs/orquestrador-reference.md). Catálogo completo de skills publicadas: [docs/skill-catalog.md](docs/skill-catalog.md).

Ferramentas que leem regras globais automaticamente já recebem os pontos de entrada conhecidos durante a instalação. Quando a ferramenta tiver regras globais em nuvem ou UI própria, mantenha o mesmo texto do `AGENTS.md` global como regra do usuário.

Em projetos que tiverem uma pasta `DEV/`, ela entra como documentação operacional local depois do `AGENTS.md` do projeto e antes das skills globais. A IA deve começar por `DEV/AGENTS.md`, `DEV/README.md`, `DEV/INDEX.md`, `DEV/PROJECT.md` ou `DEV/CONTEXT.md`, e abrir só os arquivos específicos necessários para a tarefa. Documentação durável do projeto deve ficar em `DEV/`, e trabalhos substanciais devem deixar uma entrada curta em `DEV/WORKLOG.md`.

Para criar a estrutura `DEV/` em um projeto:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project-dev.ps1 -ProjectPath "C:\caminho\do\projeto"
```

Depois da instalação, também dá para usar o helper local:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.orquestrador\bin\init-project-dev.ps1" -ProjectPath "C:\caminho\do\projeto"
```

## Opções De Instalação

Instalar completo, mas sem sobrescrever automaticamente o núcleo se já existir:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -NoForce
```

Instalar só o núcleo Orquestrador e o `AGENTS.md`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -CoreOnly
```

Instalar sem hooks/perfis das ferramentas:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -NoToolProfiles
```

Instalar em outro diretório de home, útil para teste:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -HomePath "C:\Temp\TestHome"
```

## O Que Este Repo Contém

- `orquestrador/`: regras, hooks, roteadores, índices, scripts e skills canônicas.
- `codex/`: skills, agentes e prompts ativos do Codex.
- `skill-library/community-skills/`: biblioteca deduplicada de skills comunitárias.
- `tool-profiles/`: hooks e perfis textuais reutilizáveis de Codex/OpenCode/Claude/Cursor/Gemini/Windsurf.
- `home/AGENTS.md`: contrato global que será instalado no home do usuário.
- `install.ps1`: instalador completo recomendado.
- `scripts/install.ps1`: instalador avançado usado pelo wrapper principal.
- `scripts/verify-install.ps1`: verificação pós-instalação.
- `scripts/sync-from-local.ps1`: atualiza o snapshot público a partir de uma máquina fonte.
- `scripts/validate-public.ps1`: valida se o repo está seguro para publicação.

## O Que Não Entra

- Tokens, chaves, credenciais, `.env`, `auth.json` e `config.toml`.
- Logs, histórico, sessões, memórias locais e backups.
- A pasta `DEV/` local deste clone; a convenção é publicada em `docs/project-dev-hierarchy.md` e nos scripts de inicialização.
- Caches, `node_modules`, builds, dist e runtimes baixados.
- Perfis completos de IDE, OAuth, navegador ou tracking.
- Caminhos reais da máquina fonte.

## Documentação

- [docs/installation.md](docs/installation.md): instalação completa, pastas criadas e troubleshooting.
- [docs/orquestrador.md](docs/orquestrador.md): visão geral, download, instalação, uso e atualização.
- [docs/orquestrador-reference.md](docs/orquestrador-reference.md): lógica interna, roteamento, hooks, perfis, agentes, sync e verificação.
- [docs/skill-catalog.md](docs/skill-catalog.md): catálogo das skills canônicas, Codex e comunitárias publicadas.
- [docs/ai-agent-operating-guide.md](docs/ai-agent-operating-guide.md): como as IAs devem resolver tarefas usando o Orquestrador.
- [docs/project-dev-hierarchy.md](docs/project-dev-hierarchy.md): hierarquia `DEV/` para documentação e memória de projetos.
- [docs/skill-packs.md](docs/skill-packs.md): composição dos pacotes de skills.
- [docs/tool-profiles.md](docs/tool-profiles.md): hooks e perfis de ferramentas.
- [docs/privacy-model.md](docs/privacy-model.md): modelo de privacidade e sanitização.
- [docs/update-flow.md](docs/update-flow.md): como atualizar este repo a partir da máquina fonte.

## Atualizar E Publicar

Na máquina fonte, depois de alterar o Orquestrador local:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-from-local.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-public.ps1
git diff -- .
```

Só faça commit e push depois de revisar o diff e confirmar que não há dados privados.
