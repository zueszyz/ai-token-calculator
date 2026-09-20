#!/bin/bash
# ═══════════════════════════════════════════════
#  macOS .command launcher (double-clickable)
# ═══════════════════════════════════════════════
DIR="$(cd "$(dirname "$0")" && pwd)"
"$DIR/launcher.sh" "$@"
