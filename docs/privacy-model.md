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
- JSON inválido no snapshot.
