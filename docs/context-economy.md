# Economia De Contexto

O Orquestrador Maestro foi desenhado para reduzir tokens por organização, não por compressão agressiva de tudo. A IA deve carregar primeiro contratos curtos, índices e roteadores; só depois abre arquivos maiores quando houver evidência de necessidade.

As referências externas mais úteis aqui são duas ideias:

- RTK: compactar saídas de comandos antes que elas entrem no contexto da IA.
- Caveman: comprimir linguagem operacional e instalar ativações consistentes em várias ferramentas.

No Orquestrador, isso vira uma regra prática: contexto mínimo suficiente, com reidratação sob demanda.

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

## Regra Para Agentes

Quando o contexto estiver grande, a IA deve responder com:

```text
Vou consultar o índice e abrir apenas os documentos necessários.
```

Depois disso, ela deve citar quais arquivos abriu e por quê. Isso mantém rastreabilidade sem gastar tokens em leitura ampla.
