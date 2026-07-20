#!/usr/bin/env bash
set -euo pipefail

# Bootstrap oficial para macOS/Linux. Pode ser executado antes da CLI existir.
PACKAGE="@iapro/orquestrador-maestro-cli"
PREFIX="${ORQUESTRADOR_NPM_PREFIX:-$HOME/.npm-global}"

if ! command -v npm >/dev/null 2>&1; then
  echo "Erro: Node.js e npm são necessários. Instale o Node.js LTS e execute novamente." >&2
  exit 1
fi

CURRENT_PREFIX="$(npm config get prefix 2>/dev/null || true)"
CURRENT_BIN="$CURRENT_PREFIX/bin"

if [ -n "$CURRENT_PREFIX" ] && [ -d "$CURRENT_BIN" ] && [ -w "$CURRENT_BIN" ]; then
  PREFIX="$CURRENT_PREFIX"
fi

if [ "$PREFIX" != "$CURRENT_PREFIX" ]; then
  echo "Configurando npm no diretório do usuário: $PREFIX"
  npm config set prefix "$PREFIX"
fi

BIN_DIR="$PREFIX/bin"
mkdir -p "$BIN_DIR"

PATH_LINE="export PATH=\"$BIN_DIR:\$PATH\""
SHELL_RC="${ZDOTDIR:-$HOME}/.zshrc"
if [ "${SHELL##*/}" != "zsh" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

if ! grep -Fqx "$PATH_LINE" "$SHELL_RC" 2>/dev/null; then
  printf '\n# Orquestrador Maestro npm bin\n%s\n' "$PATH_LINE" >> "$SHELL_RC"
fi

export PATH="$BIN_DIR:$PATH"
npm install -g "$PACKAGE@latest"
hash -r 2>/dev/null || true

echo "Orquestrador instalado em: $(command -v orquestrador-maestro)"
orquestrador-maestro install
orquestrador-maestro verify
echo "Instalação concluída. Abra um novo terminal se o comando não estiver disponível em outra sessão."
