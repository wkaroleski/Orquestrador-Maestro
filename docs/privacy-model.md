# Modelo De Privacidade

Este repo compartilha comportamento e estrutura, não o conteúdo privado da máquina original.

## Incluído

- Regras globais do Orquestrador.
- Índices e roteadores de skills.
- Skills canônicas sob `orquestrador/skills`.
- Skills, agentes e prompts Codex sob `codex/`.
- Biblioteca comunitária deduplicada sob `skill-library/community-skills/`.
- Hooks e perfis textuais selecionados sob `tool-profiles/`.
- Scripts de manutenção que usam caminhos relativos ao home do usuário.
- Um `AGENTS.md` global sanitizado para instalação.

## Excluído

- Caches e runtimes de ferramentas.
- Logs, backups, relatórios de doctor, memórias e histórico de execução.
- Artefatos operacionais locais como `.omx/`, `.local/` e `DEV/` deste clone.
- Configurações com projetos locais, tokens, chaves, credenciais ou caminhos reais.
- Arquivos temporários e cópias `.bak`.
- Dependências vendorizadas como `node_modules` e artefatos de build/runtime.
- Perfis completos de IDE, OAuth, navegador, tracking e sessões de agentes.

## Placeholders

O snapshot público usa placeholders:

- `{{USER_HOME}}`: home do usuário que instalar.
- `{{USER_NAME}}`: nome do usuário local.
- `{{USER_FULL_NAME}}`: nome humano opcional, quando existir na fonte.
- `<PRIVATE_TERM>`: termo privado removido durante o sync.

O instalador substitui esses placeholders por valores da máquina de destino quando copia os arquivos para o home do usuário.

## Telemetria

O CLI npm pode enviar telemetria anônima quando houver endpoint configurado. O objetivo é medir uso técnico do pacote, não identificar pessoas.

Permitido:

- comando executado;
- flags sem valores;
- versão do pacote;
- plataforma, arquitetura e versão major do Node.js;
- exit code;
- sucesso ou falha;
- identificador anônimo aleatório.

Proibido:

- telefone;
- nome de usuário;
- caminho local;
- conteúdo de projeto;
- tokens, prompts, logs ou nomes de arquivos privados.

A telemetria pode ser desabilitada com:

```bash
orquestrador-maestro telemetry disable
```

Ou por variável de ambiente:

```bash
ORQUESTRADOR_MAESTRO_TELEMETRY=0
```

## Checagem

Use:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-public.ps1
```

A validação procura:

- Caminhos concretos de home local, que devem aparecer como `{{USER_HOME}}` ou `%USERPROFILE%`.
- Nome de usuário local.
- Padrões comuns de segredo, como tokens GitHub, OpenAI, AWS e Slack.
- Diretórios proibidos como `logs` e `backups`.
- Raízes locais privadas como `.omx/`, `.local/` e `DEV/`.
- JSON inválido no snapshot.
