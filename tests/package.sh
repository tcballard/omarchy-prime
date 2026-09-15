#!/bin/bash
set -euo pipefail
# This harness installs/removes packages and supplies a fake browser.
[[ ${OMARCHY_DISPOSABLE_PACKAGE_TEST:-} == 1 && -e /run/omarchy-package-test-container ]] || {
  echo 'Run only in the disposable CI container.' >&2; exit 1;
}
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root/packaging"
useradd -m package-test
chown -R package-test:package-test "$root"
runuser -u package-test -- makepkg --nodeps --cleanbuild --force
pkg=$(find . -maxdepth 1 -name 'omarchy-prime-*.pkg.tar.zst' -print -quit)
[[ -n $pkg ]]
bsdtar -tf "$pkg" > package-files.txt
if grep -Eq '^(home|root|etc)/' package-files.txt; then exit 1; fi
namcap PKGBUILD "$pkg" | tee namcap.txt
# Chrome is deliberately absent. This tests packaging, not dependency availability or DRM.
pacman -U --noconfirm --assume-installed google-chrome=999 "$pkg"
desktop-file-validate /usr/share/applications/omarchy-prime.desktop
grep -Fx 'Name=Prime' /usr/share/applications/omarchy-prime.desktop
[[ $(pacman -Qoq /usr/bin/omarchy-prime) == omarchy-prime ]]
cat > /usr/bin/google-chrome-stable <<'BROWSER'
#!/bin/bash
printf '%s\n' "$@" > "$HOME/browser-args"
BROWSER
chmod 755 /usr/bin/google-chrome-stable
runuser -u package-test -- bash -s -- "$root" <<'USER'
set -euo pipefail
export XDG_DATA_HOME="$HOME/data space" XDG_CONFIG_HOME="$HOME/config space"
export WAYLAND_DISPLAY=''
omarchy-prime
grep -Fx -- '--app=https://www.primevideo.com/' "$HOME/browser-args"
grep -Fx -- "--user-data-dir=$XDG_CONFIG_HOME/omarchy-prime/chrome" "$HOME/browser-args"
[[ $(stat -c %a "$XDG_CONFIG_HOME/omarchy-prime/chrome") == 700 ]]
echo saved > "$XDG_CONFIG_HOME/omarchy-prime/chrome/login-marker"
mkdir -p "$XDG_CONFIG_HOME/other-app"
echo unrelated > "$XDG_CONFIG_HOME/other-app/keep"
bash "$1/install.sh"
# A changed local helper must be preserved and migration refused.
echo '# custom' >> "$XDG_DATA_HOME/omarchy-prime/omarchy-prime"
if omarchy-prime-migrate-local; then exit 1; fi
[[ -f "$XDG_DATA_HOME/applications/omarchy-prime.desktop" ]]
bash "$1/install.sh"
omarchy-prime-migrate-local
omarchy-prime-migrate-local
[[ ! -e "$XDG_DATA_HOME/applications/omarchy-prime.desktop" ]]
[[ ! -e "$XDG_DATA_HOME/omarchy-prime/omarchy-prime" ]]
[[ $(find "$XDG_DATA_HOME/omarchy-app-migration" -name omarchy-prime.desktop | wc -l) == 1 ]]
grep -Fx saved "$XDG_CONFIG_HOME/omarchy-prime/chrome/login-marker"
grep -Fx unrelated "$XDG_CONFIG_HOME/other-app/keep"
omarchy-prime
USER
# Build a second package revision and perform an actual upgrade.
sed -i 's/^pkgrel=1$/pkgrel=2/' PKGBUILD
runuser -u package-test -- makepkg --nodeps --force
upgrade=$(find . -maxdepth 1 -name 'omarchy-prime-*-2-x86_64.pkg.tar.zst' -print -quit)
pacman -U --noconfirm --assume-installed google-chrome=999 "$upgrade"
pacman -Q omarchy-prime | grep -F '0.1.0pre1-2'
pacman -R --noconfirm omarchy-prime
[[ ! -e /usr/bin/omarchy-prime && ! -e /usr/share/applications/omarchy-prime.desktop ]]
grep -Fx saved '/home/package-test/config space/omarchy-prime/chrome/login-marker'
grep -Fx unrelated '/home/package-test/config space/other-app/keep'
sed -i 's/^pkgrel=2$/pkgrel=1/' PKGBUILD
runuser -u package-test -- makepkg --printsrcinfo > .SRCINFO
sha256sum ./*.pkg.tar.zst > PACKAGE-SHA256SUMS
printf 'PASS: package build, install, migration refusal/backup/idempotence, profile preservation, upgrade and removal.\n'
