#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

if ! command -v mise > /dev/null; then
  echo "mise is required: https://mise.jdx.dev/getting-started.html" >&2
  exit 1
fi

# Ensure submodule URLs match .gitmodules (fixes stale local cache after URL changes)
git -C "$SCRIPT_DIR" submodule sync --quiet

mise trust --quiet "$SCRIPT_DIR"
mise -C "$SCRIPT_DIR" install || exit $?
eval "$(mise -C "$SCRIPT_DIR" env)"

# If this script is being executed (not sourced) and has an argument, run it with bun
[[ "${BASH_SOURCE[0]}" == "${0}" && -n "${1}" ]] && exec bun "$@"
