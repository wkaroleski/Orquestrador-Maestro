#!/usr/bin/env bash
set -euo pipefail

KEEP_TEMP=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --keep-temp)
      KEEP_TEMP=true
      ;;
    --help|-h)
      sed -n '2,20p' "$0"
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
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)"
TEMP_HOME="$(mktemp -d "${TMPDIR:-/tmp}/orquestrador-install-test.XXXXXX")"

cleanup() {
  if [ "$KEEP_TEMP" = true ]; then
    echo "TempHome kept: $TEMP_HOME"
  else
    rm -rf "$TEMP_HOME"
  fi
}
trap cleanup EXIT

bash "$REPO_ROOT/install.sh" --home-path "$TEMP_HOME" --core-only --skip-skill-sync --dry-run
bash "$REPO_ROOT/install.sh" --home-path "$TEMP_HOME" --core-only --skip-skill-sync
bash "$REPO_ROOT/scripts/verify-install.sh" --home-path "$TEMP_HOME" --core-only
bash "$REPO_ROOT/install.sh" --home-path "$TEMP_HOME" --list-targets
bash "$REPO_ROOT/install.sh" --home-path "$TEMP_HOME" --uninstall --dry-run
bash "$REPO_ROOT/install.sh" --home-path "$TEMP_HOME" --uninstall

if [ -e "$TEMP_HOME/.orquestrador" ]; then
  echo "Error: uninstall left .orquestrador behind." >&2
  exit 1
fi
if [ -e "$TEMP_HOME/AGENTS.md" ]; then
  echo "Error: uninstall left AGENTS.md behind." >&2
  exit 1
fi

echo "Installer smoke test passed."
