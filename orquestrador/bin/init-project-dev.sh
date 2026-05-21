#!/usr/bin/env bash
set -euo pipefail

# Orquestrador Maestro - Project DEV initializer
# Usage: bash ~/.orquestrador/bin/init-project-dev.sh [project_path]

PROJECT_PATH="${1:-$(pwd)}"
mkdir -p "$PROJECT_PATH"
PROJECT_ROOT="$(CDPATH= cd -- "$PROJECT_PATH" && pwd -P)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"
DEV_ROOT="$PROJECT_ROOT/DEV"
CREATED_COUNT=0
TOTAL_FILES=8

write_text_file_if_missing() {
  local path="$1"
  local content
  content="$(cat)"
  content="${content//\{\{PROJECT_NAME\}\}/$PROJECT_NAME}"

  if [ -e "$path" ]; then
    return 1
  fi

  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$content" > "$path"
  return 0
}

mkdir -p "$DEV_ROOT"

SUBDIRS=(
  "ADR"
  "API"
  "DATABASE"
  "LOGS"
  "SQL"
  "ARCH"
  "WORKFLOWS"
  "TESTS"
  "DOCUMENTATION"
  "BACKLOG"
  "RUNBOOKS"
  "TASKS"
  "RESEARCH"
  "HANDOFFS"
)

for subdir in "${SUBDIRS[@]}"; do
  mkdir -p "$DEV_ROOT/$subdir"
done

if write_text_file_if_missing "$DEV_ROOT/README.md" <<'EOF'
# DEV - {{PROJECT_NAME}}

Compact operational documentation and project memory.

Start with:

1. `INDEX.md`
2. `CONTEXT.md`
3. The task-specific document

Do not bulk-load the full `DEV/` folder by default.
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/INDEX.md" <<'EOF'
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
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/CONTEXT.md" <<'EOF'
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
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/WORKLOG.md" <<'EOF'
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
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/ARCHITECTURE.md" <<'EOF'
# Architecture

Record the living project architecture, main components, integrations, and boundaries.
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/DECISIONS.md" <<'EOF'
# Decisions

Record consolidated technical decisions. Use `ADR/` for decisions that need more detail.
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/TESTING.md" <<'EOF'
# Testing And Verification

## Commands

-

## Strategy

-
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

if write_text_file_if_missing "$DEV_ROOT/ROADMAP.md" <<'EOF'
# Roadmap

Use this file for product or engineering direction when active planning exists.
EOF
then
  CREATED_COUNT=$((CREATED_COUNT + 1))
fi

echo "ProjectPath: $PROJECT_ROOT"
echo "DevPath: $DEV_ROOT"
echo "CreatedFiles: $CREATED_COUNT"
echo "ExistingFilesPreserved: $((TOTAL_FILES - CREATED_COUNT))"
