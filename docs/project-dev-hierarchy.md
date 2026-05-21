# Hierarquia DEV Dos Projetos

Nos projetos que usam o Orquestrador Maestro, `DEV/` é a raiz canônica de documentação e memória operacional do projeto.

A intenção é economizar tokens: a IA lê primeiro índices curtos, entende o estado atual e só abre os detalhes necessários para a tarefa.

## Estrutura Recomendada

```text
DEV/
  README.md
  INDEX.md
  CONTEXT.md
  WORKLOG.md
  ARCHITECTURE.md
  DECISIONS.md
  ADR/
  API/
  DATABASE/
  RUNBOOKS/
  TASKS/
  RESEARCH/
  HANDOFFS/
```

Hierarquias existentes também são válidas. Se o projeto já usa `DEV/LOGS/`, `DEV/SQL/`, `DEV/ARCH/`, `DEV/WORKFLOWS/`, `DEV/TESTS/`, `DEV/DOCUMENTATION/` ou `DEV/BACKLOG/`, a IA deve respeitar esses caminhos e mapear tudo em `DEV/INDEX.md`, sem renomear por padrão.

Arquivos essenciais:

- `DEV/README.md`: entrada curta da documentação do projeto.
- `DEV/INDEX.md`: mapa dos documentos disponíveis.
- `DEV/CONTEXT.md`: estado atual, restrições, comandos, riscos e decisões vivas.
- `DEV/WORKLOG.md`: hook cronológico curto do que foi feito.

## Ordem De Leitura Da IA

1. `AGENTS.md` do projeto, se existir.
2. `DEV/README.md` ou `DEV/INDEX.md`.
3. `DEV/CONTEXT.md`.
4. Documentos específicos da tarefa.
5. Skills globais do Orquestrador.

A IA não deve carregar a pasta `DEV/` inteira por padrão.

## Hook De Trabalho

Depois de trabalho substancial, a IA deve registrar uma entrada curta em `DEV/WORKLOG.md`:

```text
## YYYY-MM-DD - Título curto

- Alterado: caminhos ou áreas mexidas.
- Motivo: uma frase.
- Verificado: comando ou checagem manual.
- Próximo contexto: só o que a próxima IA precisa saber.
```

Também deve atualizar:

- `DEV/INDEX.md` quando criar, renomear ou remover documentação.
- `DEV/CONTEXT.md` quando mudar estado atual, comandos, arquitetura, ambiente ou riscos.
- O arquivo específico da sub-hierarquia quando uma decisão ou fato durável mudar.

Se o projeto tiver `DEV/LOGS/`, logs longos ficam lá. `DEV/WORKLOG.md` deve guardar só o resumo compacto para a próxima sessão.

## Criar DEV Em Um Projeto

Depois de instalar o Orquestrador, rode no clone deste repositório:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project-dev.ps1 -ProjectPath "C:\caminho\do\projeto"
```

No Linux/macOS:

```bash
bash scripts/init-project-dev.sh /caminho/do/projeto
```

Ou pelo helper instalado no usuário:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.orquestrador\bin\init-project-dev.ps1" -ProjectPath "C:\caminho\do\projeto"
```

No Linux/macOS:

```bash
bash "$HOME/.orquestrador/bin/init-project-dev.sh" /caminho/do/projeto
```

O script cria a estrutura base sem sobrescrever arquivos existentes.
