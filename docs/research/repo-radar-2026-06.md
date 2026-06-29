# Radar De Junho 2026

Data da revisão: `2026-06-26`

Objetivo: avaliar referências externas úteis para UX/UI, empacotamento, atualização, skills e ingestão segura de bibliotecas privadas sem copiar código ou conteúdo protegido para o snapshot público.

## Fontes Revisadas

| Fonte | Tipo | Evidência observada | O que extrair | Decisão para o Orquestrador |
|---|---|---|---|---|
| [`tenfoldmarc/website-builder-setup`](https://github.com/tenfoldmarc/website-builder-setup) | skill-pack focado em setup | último commit observado em `2026-04-16` (`83d94da`) | onboarding por resultado, fluxo passo a passo, linguagem simples para quem não é técnico | **Adotar o padrão**, mas sem copiar o skill nem depender de repo sem licença explícita |
| [`bradautomates/claude-video`](https://github.com/bradautomates/claude-video) | skill/plugin multi-superfície | release `0.1.3` em `2026-05-09`; MIT | `CHANGELOG.md` separado, empacotamento multi-superfície, preflight/setup e comando claro de update | **Adotar o padrão** com `CHANGELOG.md` canônico e CLI com `doctor`/`changelog` |
| [`anthropics/claude-cookbooks`](https://github.com/anthropics/claude-cookbooks) | cookbook e registry de padrões | último commit observado em `2026-06-09` (`34022c5`); MIT | registry datado, categorias, observabilidade, context engineering, frontend aesthetics, managed agents | **Adotar o padrão** de radar estruturado, referências datadas e UX/UI stack intencional |
| [Google Drive “CS Fundamentals(Lets Code)”](https://drive.google.com/drive/folders/18FBvExqEtt9mtNKKP65f_ETdtS7nCG1G) | biblioteca pública de estudo e referência | snapshot público visível em `2026-06-26`; itens mostrados com datas `2024-09-04`, `2025-03-16`, `2025-05-25` e `2025-10-08` | necessidade de consumir bibliotecas privadas/publicadas por índice, não por dump completo | **Não redistribuir conteúdo**; criar padrão de `reference packs` locais |

## O Que A Biblioteca Do Drive Mostra

A pasta pública exposta no Google Drive contém pelo menos:

- pastas `Computer Network`, `DBMS & SQL`, `DSA`, `OOPs`, `Operating System`, `Software Engineering` e `System Design`;
- documentos como `Lets Code.pdf`, `Lets Code Resoures`, `HR Interview Questions.pdf`, `leetcode problems.pdf` e templates de currículo/carta.

Esse tipo de acervo é útil como biblioteca de apoio para agentes, mas não deve ser embutido no repositório público por três motivos:

1. origem/licença nem sempre estão claras;
2. o valor está no índice e no roteamento, não em despejar centenas de páginas no contexto;
3. muita gente vai querer fazer o mesmo com PDFs internos, runbooks, normas e documentação privada.

## Decisões Convertidas Em Produto

### 1. Update flow explícito

Inspirado em `claude-video`, o Orquestrador agora passa a tratar release notes e diagnóstico como parte do produto, não só da manutenção:

- `CHANGELOG.md` canônico no pacote;
- `orquestrador-maestro changelog`;
- `orquestrador-maestro doctor`;
- fluxo recomendado para instalados: `npm update -g`, `changelog`, `update`, `verify`, `doctor`.

### 2. UX/UI stack intencional

`website-builder-setup` e o cookbook de frontend aesthetics reforçam que UX/UI bom não nasce de um prompt genérico. No Orquestrador, o caminho recomendado fica:

1. `skill-open-design-ui`: direção visual, tokens, biblioteca e QA visual.
2. `skill-modern-ui-patterns`: implementação operacional para SaaS, admin e produto.
3. `skill-frontend-ux-guardrails`: gate final de responsividade, overflow, acessibilidade, ortografia e estados.

### 3. Reference packs locais

O Drive mostrou a necessidade de um padrão seguro para bibliotecas externas. Em vez de publicar material de terceiros, o Orquestrador passa a documentar:

- índice local primeiro;
- leitura por demanda;
- nada de bulk-load de uma pasta inteira;
- nada disso entra no snapshot público.

## O Que Não Foi Adotado

- copiar `SKILL.md`, texto, assets ou estrutura inteira de repositórios externos;
- depender de instalação “mágica” de terceiros sem deixar o fluxo auditável;
- vender código de terceiros ou materiais do Drive dentro do pacote público;
- carregar automaticamente pastas enormes do usuário só porque elas existem.

## Próximos Passos Recomendados

1. Publicar a próxima versão npm depois de validar `doctor` e `changelog` no pacote empacotado.
2. Criar um pequeno status/release checklist visual no README para reduzir erro humano de update.
3. Avaliar um registry leve de referências externas curadas, no estilo `registry.yaml`, se o volume de pesquisas crescer.
4. Manter a UX/UI stack como convenção documentada e não como prompt solto em conversa.
