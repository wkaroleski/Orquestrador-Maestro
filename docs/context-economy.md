# Economia De Contexto

O Orquestrador Maestro foi desenhado para reduzir tokens por organização, não por compressão agressiva de tudo. A IA deve carregar primeiro contratos curtos, índices e roteadores; só depois abre arquivos maiores quando houver evidência de necessidade.

As referências externas mais úteis aqui são duas ideias:

- RTK: compactar saídas de comandos antes que elas entrem no contexto da IA.
- Caveman: comprimir linguagem operacional e instalar ativações consistentes em várias ferramentas.

No Orquestrador, isso vira uma regra prática: contexto mínimo suficiente, com reidratação sob demanda.

## Atualização Maio 2026

O radar recente em [docs/research/repo-radar-2026-05.md](research/repo-radar-2026-05.md) reforçou que economia de contexto não deve depender só de resumo automático. Os padrões mais úteis são:

- **contratos curtos antes de documentos longos**: `AGENTS.md`, `rules.md`, `maestro.md`, índices e roteadores precisam responder "o que ler agora" antes de qualquer catálogo grande;
- **gates explícitos**: tarefas longas devem ter plano, execução, verificação e handoff em arquivos pequenos, para evitar que a próxima IA reconstrua tudo do zero;
- **telemetria e rastreio opt-in**: qualquer sessão, trace ou métrica deve ser local-first, redigida e desativável, sem prompts, tokens, caminhos privados ou logs completos;
- **subagentes como isolamento de contexto**: subagentes ajudam quando recebem escopo estreito, posse clara e devolvem achados resumidos, não quando todos leem o mesmo repositório inteiro;
- **MCP como camada opcional**: integrações MCP devem vir com templates por cliente e alertas de privacidade, especialmente quando a ferramenta expõe navegador, terminal ou arquivos;
- **release channels com disciplina**: canais como `preview` e `nightly` só fazem sentido quando houver automação, changelog e validação suficientes para o usuário entender o risco.

Esses pontos mantêm o Orquestrador como uma camada de engenharia de contexto: ele organiza o que a IA precisa saber, quando deve saber e como deve registrar o mínimo útil para a próxima execução.

## Camadas De Leitura

Ordem recomendada para qualquer IA instalada:

1. `AGENTS.md` global do usuário.
2. `.orquestrador/rules.md`.
3. `.orquestrador/maestro.md`.
4. `AGENTS.md` do projeto atual.
5. `DEV/README.md`, `DEV/INDEX.md` ou `DEV/CONTEXT.md`, se existirem.
6. Roteadores compactos de skill.
7. `SKILL.md` específico da tarefa.
8. Referências internas da skill somente quando necessárias.

A IA não deve abrir `skill-library/community-skills/` inteira, nem carregar a árvore `DEV/` completa por padrão.

## Arquivos Que Economizam Tokens

| Arquivo | Uso esperado |
|---|---|
| `SKILLS_INDEX.md` | Descobrir grupos de skills sem abrir o catálogo completo. |
| `SKILL_ALIASES.json` | Traduzir termos do usuário para uma skill canônica. |
| `SKILLS_ROUTER.json` | Confirmar skill, gatilhos, custo e risco. |
| `SKILL_CHAINS.json` | Saber quais skills auxiliares podem ser chamadas. |
| `SKILL_EXECUTION_PROFILES.json` | Limitar profundidade, paralelismo e validação. |
| `DEV/INDEX.md` | Mapear documentação local do projeto. |
| `DEV/CONTEXT.md` | Recuperar estado atual sem reler todo o projeto. |
| `DEV/WORKLOG.md` | Entender alterações recentes em poucas linhas. |

## Saídas De Comandos

A inspiração do RTK deve entrar como uma camada opcional. O Orquestrador não deve instalar reescrita automática de comandos por padrão.

Padrão recomendado:

- Começar por comandos compactos: `git status --short`, `git diff --stat`, `rg --files`, `rg "termo"`.
- Para testes, priorizar falhas e resumos antes de logs completos.
- Guardar saída longa em arquivo local quando útil e resumir só o necessário na resposta.
- Usar saída completa apenas quando o diagnóstico depender dela.

Roadmap seguro:

1. Criar wrappers opt-in para `status`, `diff`, `test`, `lint`, `tree` e `read`.
2. Preservar exit code e stderr.
3. Ter flag de saída bruta.
4. Não registrar comandos com segredos.
5. Não ativar hooks de reescrita sem consentimento explícito.

## Compressão De DEV

Uma futura skill de compressão pode resumir documentos longos em `DEV/`, desde que preserve:

- comandos;
- paths;
- URLs;
- blocos de código;
- decisões;
- riscos;
- referências de arquivos;
- datas e autores quando forem relevantes.

Ela não deve comprimir `.env`, configs com credenciais, lockfiles, bancos locais, logs privados ou código-fonte.

## Templates DEV Recomendados

Para tarefas longas, a próxima evolução do Orquestrador deve favorecer arquivos pequenos e previsíveis:

| Arquivo | Finalidade |
|---|---|
| `DEV/PLAN.md` | Objetivo, limites, tarefas e comandos de verificação antes da execução. |
| `DEV/IMPLEMENT.md` | Decisões tomadas, desvios do plano e arquivos tocados. |
| `DEV/VERIFY.md` | Comandos executados, resultado, falhas e evidência final. |
| `DEV/HANDOFF.md` | Contexto mínimo para outra IA continuar sem reler tudo. |

Esses templates devem complementar `DEV/WORKLOG.md`, não substituir. O `WORKLOG` continua sendo o índice cronológico curto; os outros arquivos entram quando a tarefa precisa de mais rastreabilidade.

## Regra Para Agentes

Quando o contexto estiver grande, a IA deve responder com:

```text
Vou consultar o índice e abrir apenas os documentos necessários.
```

Depois disso, ela deve citar quais arquivos abriu e por quê. Isso mantém rastreabilidade sem gastar tokens em leitura ampla.
