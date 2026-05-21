#!/usr/bin/env bash
set -euo pipefail

# Orquestrador Maestro - Unix installer engine
# Usage: bash scripts/install.sh [--home-path PATH] [--force] [--skip-skill-sync] [--skip-extra-skills] [--skip-community-skills] [--install-tool-profiles]

HOME_PATH="${HOME:-}"
FORCE=false
SKIP_SKILL_SYNC=false
SKIP_EXTRA_SKILLS=false
SKIP_COMMUNITY_SKILLS=false
INSTALL_TOOL_PROFILES=false

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
    --force)
      FORCE=true
      ;;
    --skip-skill-sync)
      SKIP_SKILL_SYNC=true
      ;;
    --skip-extra-skills)
      SKIP_EXTRA_SKILLS=true
      ;;
    --skip-community-skills)
      SKIP_COMMUNITY_SKILLS=true
      ;;
    --install-tool-profiles)
      INSTALL_TOOL_PROFILES=true
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

if [ "$HOME_PATH" = "/" ]; then
  echo "Error: refusing to install into filesystem root." >&2
  exit 1
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)"
SOURCE_ORQUESTRADOR="$REPO_ROOT/orquestrador"
SOURCE_AGENTS="$REPO_ROOT/home/AGENTS.md"
SOURCE_CODEX="$REPO_ROOT/codex"
SOURCE_COMMUNITY_SKILLS="$REPO_ROOT/skill-library/community-skills"
SOURCE_TOOL_PROFILES="$REPO_ROOT/tool-profiles"

TARGET_ORQUESTRADOR="$HOME_PATH/.orquestrador"
TARGET_AGENTS="$HOME_PATH/AGENTS.md"
BACKUP_ROOT="$HOME_PATH/.orquestrador-public-backups"
STAMP="$(date +"%Y%m%d-%H%M%S")"
BACKUP_DIR="$BACKUP_ROOT/$STAMP"
USER_NAME="$(basename "$HOME_PATH")"

TARGETS=()
FILE_TARGETS=()
BACKED_UP_DESTINATIONS=()

is_text_file() {
  local file="$1"
  local leaf ext
  leaf="$(basename "$file")"
  ext="${leaf##*.}"

  if [ "$leaf" = ".gitignore" ]; then return 0; fi
  if [ "$ext" = "$leaf" ]; then return 0; fi

  case "$ext" in
    md|mdc|txt|json|jsonl|toml|yaml|yml|ps1|cmd|sh|js|jsx|ts|tsx|mjs|cjs|py|rb|go|rs|java|kt|swift|c|h|cpp|hpp|cs|html|css|scss|svg|xsd|xml|csv|patch|template|rules|ini|cfg|conf|sql)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'
}

copy_with_placeholders() {
  local src="$1"
  local dest="$2"
  local dest_dir home_for_text user_for_text full_name_for_text

  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if ! is_text_file "$src"; then
    cp "$src" "$dest"
    return
  fi

  home_for_text="$(escape_sed_replacement "$HOME_PATH")"
  user_for_text="$(escape_sed_replacement "$USER_NAME")"
  full_name_for_text="$user_for_text"

  sed -e "s|{{USER_HOME}}|$home_for_text|g" \
    -e "s|{{USER_NAME}}|$user_for_text|g" \
    -e "s|{{USER_FULL_NAME}}|$full_name_for_text|g" \
    "$src" > "$dest"
}

copy_tree_with_placeholders() {
  local src_dir="$1"
  local dest_dir="$2"
  local src_file relative dest_file

  [ -d "$src_dir" ] || return 0

  while IFS= read -r -d '' src_file; do
    relative="${src_file#$src_dir/}"
    dest_file="$dest_dir/$relative"
    copy_with_placeholders "$src_file" "$dest_file"
  done < <(find "$src_dir" -type f -print0)
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

backup_path() {
  local path="$1"
  local label="$2"
  local seen

  [ -e "$path" ] || return 0

  for seen in "${BACKED_UP_DESTINATIONS[@]}"; do
    if [ "$seen" = "$path" ]; then
      return 0
    fi
  done

  mkdir -p "$BACKUP_DIR"
  cp -R "$path" "$BACKUP_DIR/$label"
  BACKED_UP_DESTINATIONS+=("$path")
}

add_target() {
  local src="$1"
  local dest="$2"
  local label="$3"
  if [ -d "$src" ]; then
    TARGETS+=("$src|$dest|$label")
  fi
}

add_file_target() {
  local src="$1"
  local dest="$2"
  local label="$3"
  if [ -f "$src" ]; then
    FILE_TARGETS+=("$src|$dest|$label")
  fi
}

if [ ! -d "$SOURCE_ORQUESTRADOR" ]; then
  echo "Error: missing generated snapshot: $SOURCE_ORQUESTRADOR" >&2
  exit 1
fi
if [ ! -f "$SOURCE_AGENTS" ]; then
  echo "Error: missing home AGENTS template: $SOURCE_AGENTS" >&2
  exit 1
fi

if [ -e "$TARGET_ORQUESTRADOR" ] && [ "$FORCE" = false ]; then
  echo "Error: target already exists: $TARGET_ORQUESTRADOR. Re-run with --force to overwrite after backup." >&2
  exit 1
fi
if [ -e "$TARGET_AGENTS" ] && [ "$FORCE" = false ]; then
  echo "Error: target already exists: $TARGET_AGENTS. Re-run with --force to overwrite after backup." >&2
  exit 1
fi

if [ "$SKIP_EXTRA_SKILLS" = false ]; then
  if [ "$SKIP_COMMUNITY_SKILLS" = false ]; then
    COMMUNITY_ROOTS=(
      ".codex/skills"
      ".agents/skills"
      ".claude/skills"
      ".opencode/skills"
      ".cursor/skills"
      ".gemini/skills"
      ".windsurf/skills"
      ".antigravity-skills/skills"
    )
    for root in "${COMMUNITY_ROOTS[@]}"; do
      add_target "$SOURCE_COMMUNITY_SKILLS" "$HOME_PATH/$root" "${root//\//__}"
    done
  fi

  add_target "$SOURCE_CODEX/skills" "$HOME_PATH/.codex/skills" ".codex__skills"
  add_target "$SOURCE_CODEX/agents" "$HOME_PATH/.codex/agents" ".codex__agents"
  add_target "$SOURCE_CODEX/prompts" "$HOME_PATH/.codex/prompts" ".codex__prompts"
fi

if [ "$INSTALL_TOOL_PROFILES" = true ]; then
  TOOL_PROFILES=(
    "codex|.codex|.codex__profile"
    "opencode|.opencode|.opencode"
    "opencode-global|.config/opencode|.config__opencode"
    "claude|.claude|.claude"
    "cursor|.cursor|.cursor"
    "gemini|.gemini|.gemini"
    "windsurf|.windsurf|.windsurf"
    "windsurf-global|.codeium/windsurf/memories|.codeium__windsurf__memories"
    "antigravity|.antigravity|.antigravity"
    "ai-standards|.ai-standards|.ai-standards"
  )
  for entry in "${TOOL_PROFILES[@]}"; do
    IFS='|' read -r src_sub dest_sub label <<EOF
$entry
EOF
    add_target "$SOURCE_TOOL_PROFILES/$src_sub" "$HOME_PATH/$dest_sub" "$label"
  done

  add_file_target "$SOURCE_TOOL_PROFILES/antigravity-home/antigravity-rules.json" "$HOME_PATH/antigravity-rules.json" "antigravity-rules.json"
fi

backup_path "$TARGET_ORQUESTRADOR" ".orquestrador"
backup_path "$TARGET_AGENTS" "AGENTS.md"

for entry in "${TARGETS[@]}"; do
  IFS='|' read -r _src dest label <<EOF
$entry
EOF
  backup_path "$dest" "$label"
done

for entry in "${FILE_TARGETS[@]}"; do
  IFS='|' read -r _src dest label <<EOF
$entry
EOF
  backup_path "$dest" "$label"
done

if [ -d "$TARGET_ORQUESTRADOR" ]; then
  if ! path_under_root "$TARGET_ORQUESTRADOR" "$HOME_PATH"; then
    echo "Error: refusing to remove target outside home: $TARGET_ORQUESTRADOR" >&2
    exit 1
  fi
  rm -rf "$TARGET_ORQUESTRADOR"
fi

copy_tree_with_placeholders "$SOURCE_ORQUESTRADOR" "$TARGET_ORQUESTRADOR"
copy_with_placeholders "$SOURCE_AGENTS" "$TARGET_AGENTS"
mkdir -p "$TARGET_ORQUESTRADOR/logs"

for entry in "${TARGETS[@]}"; do
  IFS='|' read -r src dest _label <<EOF
$entry
EOF
  copy_tree_with_placeholders "$src" "$dest"
done

for entry in "${FILE_TARGETS[@]}"; do
  IFS='|' read -r src dest _label <<EOF
$entry
EOF
  copy_with_placeholders "$src" "$dest"
done

chmod +x "$TARGET_ORQUESTRADOR/sync-skills.sh" "$TARGET_ORQUESTRADOR/bin/init-project-dev.sh" 2>/dev/null || true

if [ "$SKIP_SKILL_SYNC" = false ]; then
  SYNC_SCRIPT="$TARGET_ORQUESTRADOR/sync-skills.sh"
  if [ -f "$SYNC_SCRIPT" ]; then
    bash "$SYNC_SCRIPT" --apply --home-path "$HOME_PATH"
  fi
fi

echo "Installation complete."
echo "HomePath: $HOME_PATH"
echo "InstalledOrquestrador: $TARGET_ORQUESTRADOR"
echo "InstalledAgents: $TARGET_AGENTS"
if [ -d "$BACKUP_DIR" ]; then
  echo "Backup: $BACKUP_DIR"
fi
echo "SkillSync: $([ "$SKIP_SKILL_SYNC" = false ] && echo true || echo false)"
echo "ToolProfiles: $INSTALL_TOOL_PROFILES"
echo "ExtraSkillTargets: ${#TARGETS[@]}"
