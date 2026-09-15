#!/bin/bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export HOME="$tmp/home space" XDG_DATA_HOME="$tmp/data space" XDG_CONFIG_HOME="$tmp/config space"
export CAPTURE="$tmp/args"
export WAYLAND_DISPLAY=''
mkdir -p "$HOME" "$tmp/bin"
export PATH="$tmp/bin:/usr/bin:/bin"
cat > "$tmp/bin/google-chrome-stable" <<'CHROME'
#!/bin/bash
printf '%s\n' "$@" > "$CAPTURE"
CHROME
chmod +x "$tmp/bin/google-chrome-stable"
for script in omarchy-prime install.sh uninstall.sh; do bash -n "$root/$script"; done
bash "$root/install.sh"
app="$XDG_DATA_HOME/omarchy-prime/omarchy-prime"
"$app"
grep -Fx -- '--app=https://www.primevideo.com/' "$CAPTURE"
grep -Fx -- "--user-data-dir=$XDG_CONFIG_HOME/omarchy-prime/chrome" "$CAPTURE"
! grep -q -- '--no-sandbox' "$CAPTURE"
[[ $(stat -c %a "$XDG_CONFIG_HOME/omarchy-prime/chrome") == 700 ]]
grep -Fx 'Icon=omarchy-prime' "$XDG_DATA_HOME/applications/omarchy-prime.desktop"
cmp "$root/prime-video.png" "$XDG_DATA_HOME/icons/hicolor/128x128/apps/omarchy-prime.png"
printf 'saved\n' > "$XDG_CONFIG_HOME/omarchy-prime/chrome/login-marker"
mkdir -p "$XDG_CONFIG_HOME/omarchy-netflix/chrome"
printf 'netflix\n' > "$XDG_CONFIG_HOME/omarchy-netflix/chrome/login-marker"
if "$app" --no-sandbox; then exit 1; fi
bash "$root/install.sh"
bash "$root/uninstall.sh"
bash "$root/uninstall.sh"
[[ ! -e $app ]]
[[ ! -e $XDG_DATA_HOME/applications/omarchy-prime.desktop ]]
[[ ! -e $XDG_DATA_HOME/icons/hicolor/128x128/apps/omarchy-prime.png ]]
grep -Fx saved "$XDG_CONFIG_HOME/omarchy-prime/chrome/login-marker"
grep -Fx netflix "$XDG_CONFIG_HOME/omarchy-netflix/chrome/login-marker"
export XDG_DATA_HOME=relative XDG_CONFIG_HOME=relative
bash "$root/install.sh"
"$HOME/.local/share/omarchy-prime/omarchy-prime"
grep -Fx -- "--user-data-dir=$HOME/.config/omarchy-prime/chrome" "$CAPTURE"
cat > "$tmp/bin/uwsm-app" <<'UWSM'
#!/bin/bash
[[ $1 == -- ]] || exit 90
shift
exec "$@"
UWSM
chmod +x "$tmp/bin/uwsm-app"
export WAYLAND_DISPLAY=wayland-test
bash "$root/omarchy-prime"
grep -Fx -- '--app=https://www.primevideo.com/' "$CAPTURE"
printf 'PASS: launcher, icon, reinstall/removal, profile preservation, XDG fallback, argument rejection, uwsm delegation.\n'
