# Fluxo De Atualização

## Fonte Da Verdade

Edite primeiro a instalação local:

```text
Windows: %USERPROFILE%\.orquestrador
Linux/macOS: $HOME/.orquestrador
```

Depois gere o snapshot público nesta pasta.

## Atualizar Snapshot

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-from-local.ps1
```

Se precisar remover termos privados específicos durante a exportação:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-from-local.ps1 -PrivateTerm "NomeDoProjeto" -PrivateTerm "ClienteInterno"
```

Também é possível manter termos privados em `.local/private-terms.txt`, um por linha. Essa pasta é ignorada pelo Git.

## Validar

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-public.ps1
```

## Revisar E Subir

```powershell
git diff -- .
git add .
git commit -m "Update public orchestrator snapshot"
git push
```

O processo não faz commit nem push automaticamente.

## Pacotes Gerados

O sync atualiza:

- `orquestrador/` com o núcleo canônico.
- `codex/` com skills, agentes e prompts Codex.
- `skill-library/community-skills/` com a biblioteca deduplicada de `.agents/skills`.
- `tool-profiles/` com hooks e perfis textuais selecionados.

Para gerar apenas o núcleo:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-from-local.ps1 -SkipCodexPack -SkipCommunitySkills -SkipToolProfiles
```

## Testar Instalação

Antes de publicar uma mudança de instalador ou documentação, teste em um home temporário:

```powershell
$tempHome = Join-Path $env:TEMP "orquestrador-public-test"
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -HomePath $tempHome
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-install.ps1 -HomePath $tempHome
```

No Linux/macOS:

```bash
bash install.sh --home-path /tmp/orquestrador-public-test
bash scripts/verify-install.sh --home-path /tmp/orquestrador-public-test
```
