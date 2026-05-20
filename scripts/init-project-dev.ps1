[CmdletBinding()]
param(
  [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$projectRoot = [System.IO.Path]::GetFullPath($ProjectPath)
$projectName = Split-Path -Leaf $projectRoot
$devRoot = Join-Path $projectRoot "DEV"

function Write-TextFileIfMissing {
  param(
    [string]$Path,
    [string]$Content
  )

  if (Test-Path -LiteralPath $Path) { return $false }

  $directory = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $directory | Out-Null
  [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
  return $true
}

New-Item -ItemType Directory -Force -Path $devRoot | Out-Null

$subdirs = @(
  "ADR",
  "API",
  "DATABASE",
  "LOGS",
  "SQL",
  "ARCH",
  "WORKFLOWS",
  "TESTS",
  "DOCUMENTATION",
  "BACKLOG",
  "RUNBOOKS",
  "TASKS",
  "RESEARCH",
  "HANDOFFS"
)

foreach ($subdir in $subdirs) {
  New-Item -ItemType Directory -Force -Path (Join-Path $devRoot $subdir) | Out-Null
}

$created = New-Object System.Collections.Generic.List[string]

$files = @(
  @{
    Name = "README.md"
    Content = @'
# DEV - {{PROJECT_NAME}}

Compact operational documentation and project memory.

Start with:

1. `INDEX.md`
2. `CONTEXT.md`
3. The task-specific document

Do not bulk-load the full `DEV/` folder by default.
'@
  },
  @{
    Name = "INDEX.md"
    Content = @'
# DEV Index

| Path | Purpose |
|---|---|
| `README.md` | Short operational documentation entrypoint |
| `CONTEXT.md` | Current state, constraints, commands, and risks |
| `WORKLOG.md` | Compact chronological hook of work done |
| `ARCHITECTURE.md` | Living project architecture |
| `DECISIONS.md` | Consolidated technical decisions |
| `ADR/` | Formal decision records |
| `API/` | API documentation |
| `DATABASE/` | Data model, migrations, and data notes |
| `TESTING.md` | Verification strategy and commands |
| `RUNBOOKS/` | Operational procedures |
| `TASKS/` | Active plans and tasks |
| `RESEARCH/` | Research and references |
| `HANDOFFS/` | Context handoffs |
| `LOGS/` | Longer execution logs |
| `SQL/` | SQL scripts and database work |
| `ARCH/` | Existing architecture sub-hierarchy |
| `WORKFLOWS/` | Active and completed workflow artifacts |
| `TESTS/` | Existing testing sub-hierarchy |
| `DOCUMENTATION/` | Existing project documentation sub-hierarchy |
| `BACKLOG/` | Existing backlog and completed work archive |
'@
  },
  @{
    Name = "CONTEXT.md"
    Content = @'
# Current Context

## State

- Project: `{{PROJECT_NAME}}`
- Update this file when commands, architecture, environment, risks, or active decisions change.

## Commands

- Install:
- Development:
- Tests:
- Build:

## Constraints And Risks

- 

## Next Context

- 
'@
  },
  @{
    Name = "WORKLOG.md"
    Content = @'
# Worklog

Record a short summary here after substantive work.

## Template

```text
## YYYY-MM-DD - Short task title

- Changed: paths or areas touched.
- Why: one sentence.
- Verified: command or manual check.
- Next context: only what the next AI needs.
```
'@
  },
  @{
    Name = "ARCHITECTURE.md"
    Content = @'
# Architecture

Record the living project architecture, main components, integrations, and boundaries.
'@
  },
  @{
    Name = "DECISIONS.md"
    Content = @'
# Decisions

Record consolidated technical decisions. Use `ADR/` for decisions that need more detail.
'@
  },
  @{
    Name = "TESTING.md"
    Content = @'
# Testing And Verification

## Commands

- 

## Strategy

- 
'@
  },
  @{
    Name = "ROADMAP.md"
    Content = @'
# Roadmap

Use this file for product or engineering direction when active planning exists.
'@
  }
)

foreach ($file in $files) {
  $path = Join-Path $devRoot $file.Name
  $content = $file.Content.Replace("{{PROJECT_NAME}}", $projectName)
  if (Write-TextFileIfMissing -Path $path -Content $content) {
    $created.Add($path)
  }
}

[pscustomobject]@{
  ProjectPath = $projectRoot
  DevPath = $devRoot
  CreatedFiles = $created.Count
  ExistingFilesPreserved = $files.Count - $created.Count
} | Format-List
