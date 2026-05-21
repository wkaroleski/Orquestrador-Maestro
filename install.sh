#!/usr/bin/env bash
set -euo pipefail

# Orquestrador Maestro - Unix installer wrapper
# Usage: bash install.sh [--home-path PATH] [--no-force] [--no-tool-profiles] [--core-only] [--skip-community-skills] [--skip-skill-sync]

HOME_PATH="${HOME:-}"
FORCE=true
TOOL_PROFILES=true
CORE_ONLY=false
SKIP_COMMUNITY_SKILLS=false
SKIP_SKILL_SYNC=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --home-path)
      if [ "$#" -lt 2 ]; then
        echo "Error: --home-path requires a value." >&2
        exit 1
      fi
      HOME_PATH="$2"
      shift
      ;;
    --no-force)
      FORCE=false
      ;;
    --no-tool-profiles)
      TOOL_PROFILES=false
      ;;
    --core-only)
      CORE_ONLY=true
      ;;
    --skip-community-skills)
      SKIP_COMMUNITY_SKILLS=true
      ;;
    --skip-skill-sync)
      SKIP_SKILL_SYNC=true
      ;;
    --help|-h)
      sed -n '2,4p' "$0"
      exit 0
      ;;
    *)
      echo "Error: unknown parameter: $1" >&2
      exit 1
      ;;
  esac
  shift
done

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ENGINE="$SCRIPT_DIR/scripts/install.sh"

if [ ! -f "$ENGINE" ]; then
  echo "Error: missing installer engine: $ENGINE" >&2
  exit 1
fi

ARGS=(--home-path "$HOME_PATH")

if [ "$FORCE" = true ]; then
  ARGS+=(--force)
fi
if [ "$TOOL_PROFILES" = true ] && [ "$CORE_ONLY" = false ]; then
  ARGS+=(--install-tool-profiles)
fi
if [ "$CORE_ONLY" = true ]; then
  ARGS+=(--skip-extra-skills)
fi
if [ "$SKIP_COMMUNITY_SKILLS" = true ]; then
  ARGS+=(--skip-community-skills)
fi
if [ "$SKIP_SKILL_SYNC" = true ]; then
  ARGS+=(--skip-skill-sync)
fi

bash "$ENGINE" "${ARGS[@]}"
