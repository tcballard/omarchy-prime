#!/bin/bash
set -euo pipefail
(( $# == 0 )) || { echo 'Usage: bash uninstall.sh' >&2; exit 2; }
data=${XDG_DATA_HOME:-}
[[ $data == /* ]] || data="$HOME/.local/share"
rm -f -- "$data/applications/omarchy-prime.desktop" "$data/omarchy-prime/omarchy-prime"
rm -f -- "$data/icons/hicolor/128x128/apps/omarchy-prime.png"
rmdir -- "$data/omarchy-prime" 2>/dev/null || true
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$data/applications" >/dev/null 2>&1 || true
fi
printf '%s\n' 'Prime Video launcher removed. Your Prime Video browser profile and login data are preserved.'
