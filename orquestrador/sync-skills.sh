#!/usr/bin/env bash
set -euo pipefail

# Orquestrador Maestro - Unix skill synchronizer
# Usage: bash ~/.orquestrador/sync-skills.sh [--check|--dry-run|--apply] [--home-path PATH]

MODE="check"
HOME_PATH="${HOME:-}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check)
      MODE="check"
      ;;
    --dry-run)
      MODE="dry-run"
      ;;
    --apply)
      MODE="apply"
      ;;
    --home-path)
      if [ "$#" -lt 2 ]; then
        echo "Error: --home-path requires a value." >&2
        exit 1
      fi
      HOME_PATH="$2"
      shift
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

if [ -z "$HOME_PATH" ]; then
  echo "Error: HOME is not set. Pass --home-path PATH." >&2
  exit 1
fi

mkdir -p "$HOME_PATH"
HOME_PATH="$(CDPATH= cd -- "$HOME_PATH" && pwd -P)"

SOURCES=(
  "$HOME_PATH/.orquestrador/skills"
  "$HOME_PATH/.global-skills"
  "$HOME_PATH/.codex/skills"
)

TARGETS=(
  "$HOME_PATH/.codex/skills"
  "$HOME_PATH/.opencode/skills"
  "$HOME_PATH/.agents/skills"
  "$HOME_PATH/.claude/skills"
  "$HOME_PATH/.cursor/skills"
  "$HOME_PATH/.gemini/skills"
  "$HOME_PATH/.windsurf/skills"
  "$HOME_PATH/.antigravity-skills/skills"
)

MANIFEST="$HOME_PATH/.orquestrador/SKILLS_MANIFEST.json"
if [ -f "$MANIFEST" ] && command -v node >/dev/null 2>&1; then
  MUST_HAVE=()
  while IFS= read -r skill_name; do
    [ -n "$skill_name" ] && MUST_HAVE+=("$skill_name")
  done < <(node -e 'const fs=require("fs"); const manifest=JSON.parse(fs.readFileSync(process.argv[1],"utf8")); for (const [name, entry] of Object.entries(manifest.skills || {}).sort()) { if (entry.mirrorEverywhere) console.log(name); }' "$MANIFEST")
else
  MUST_HAVE=(
    "skill-saas-factory"
    "skill-saas-admin-dashboard"
    "skill-abacatepay-integration"
    "skill-stripe-integration"
    "skill-saas-core-limits"
    "skill-supabase-rls"
    "skill-saas-security-scan"
    "skill-saas-dast-recon"
    "skill-security-hooks"
    "skill-ai-orchestration"
    "skill-multiagent-orchestration"
    "skill-aionui-cowork-orchestration"
    "skill-evolution-api"
    "skill-frontend-ux-guardrails"
    "skill-modern-ui-patterns"
    "skill-open-design-ui"
    "skill-live-processing"
    "skill-manual-video-processing"
    "skill-smart-clip-detection"
    "skill-unified-analytics"
    "skill-elevenlabs-voice-cloning"
    "skill-google-workspace-sync"
  )
fi

get_skill_source() {
  local name="$1"
  local root candidate
  for root in "${SOURCES[@]}"; do
    candidate="$root/$name"
    if [ -f "$candidate/SKILL.md" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

skill_different() {
  local src="$1"
  local dest="$2"

  if [ ! -d "$dest" ]; then
    return 0
  fi

  if diff -qr "$src" "$dest" >/dev/null 2>&1; then
    return 1
  fi
  return 0
}

path_under_root() {
  local path="$1"
  local root="$2"
  local resolved_path resolved_root

  mkdir -p "$(dirname "$path")"
  resolved_path="$(CDPATH= cd -- "$(dirname "$path")" && pwd -P)/$(basename "$path")"
  resolved_root="$(CDPATH= cd -- "$root" && pwd -P)"

  case "$resolved_path" in
    "$resolved_root"/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

copy_skill() {
  local src="$1"
  local dest="$2"
  local target_root="$3"

  if [ -d "$dest" ]; then
    if ! path_under_root "$dest" "$target_root"; then
      echo "Refusing to remove destination outside target root: $dest" >&2
      return 1
    fi
    rm -rf "$dest"
  fi

  mkdir -p "$dest"
  cp -R "$src"/. "$dest"/
}

printf 'Target\tSkill\tSource\tAction\n'

for target in "${TARGETS[@]}"; do
  target_exists=false
  if [ -d "$target" ]; then
    target_exists=true
  fi

  for skill in "${MUST_HAVE[@]}"; do
    src="$(get_skill_source "$skill" || true)"
    dest="$target/$skill"
    action="ok"

    if [ -z "$src" ]; then
      action="missing-source"
    elif [ "$target_exists" = false ]; then
      action="missing-target"
    elif [ ! -f "$dest/SKILL.md" ]; then
      action="copy"
    elif skill_different "$src" "$dest"; then
      action="update"
    fi

    if [ "$MODE" = "apply" ] && [ -n "$src" ]; then
      if [ "$action" = "missing-target" ] || [ "$action" = "copy" ] || [ "$action" = "update" ]; then
        mkdir -p "$target"
        copy_skill "$src" "$dest" "$target"
        action="applied"
      fi
    fi

    printf '%s\t%s\t%s\t%s\n' "$target" "$skill" "${src:-}" "$action"
  done
done
