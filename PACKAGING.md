# Pacman packaging preview

Status: development packaging, version `0.1.0pre1-1`. No official Omarchy inclusion or vendor endorsement. The existing user-local installer remains available.

## Build and install on x86_64 Arch / Omarchy

Requires `base-devel`, `git`, and **Google Chrome already installed as the `google-chrome` package**. This recipe deliberately does not install a browser from an arbitrary source. The current Omarchy package tree provides `omarchy-chromium-bin`, not Google Chrome; resolving that browser choice is required before an upstream submission.

From this checkout, as your ordinary user:

```bash
cd packaging
makepkg -f
sudo pacman -U ./omarchy-prime-0.1.0pre1-1-x86_64.pkg.tar.zst
omarchy-prime-migrate-local
```

The migration command runs without sudo, after the package is installed. It backs up the previous local desktop entry, matching helper and matching icon under `$XDG_DATA_HOME/omarchy-app-migration/` (default `~/.local/share/omarchy-app-migration/`). It refuses modified helpers/icons and symlinked files. It can be rerun. It never moves or removes the browser profile. If a local file has been customised, review it manually. The package itself has no installation or removal hooks that edit home directories.

Both launch methods use the existing `$XDG_CONFIG_HOME/omarchy-prime/chrome` profile. Close the app before upgrading. To update, install a newer package with `pacman -U`; automatic updates require a configured repository publishing this package. To remove:

```bash
sudo pacman -R omarchy-prime
```

Removal preserves login data and migration backups. To return to the local installation, remove the package and rerun `bash install.sh` from the repository root. Avoid running the local installer while the package is installed, because its desktop entry overrides the system entry.

## Sources and release route

The recipe pins the existing launcher source to commit `bfa9fd9bc45eb3aff3d5feaa6fe0581804affda0` and a SHA-256 digest. New desktop and migration files are separately checksummed. It installs only `/usr/bin`, `/usr/share/applications`, icons and licence notices. Social preview artwork is excluded.

`packaging/.omarchy/package.json` is prepared as local-source metadata for a future `pkgbuilds/omarchy-prime/` contribution. No upstream watch is declared yet: this is a commit-pinned development preview, not a tagged supported release. Before submission: settle the Omarchy browser dependency, perform actual Omarchy playback and desktop acceptance, review icon redistribution, then tag a release and pin its archive/digest with a release watch.

Official packaging implementation inspected at `omacom/omarchy-pkgs@5fe236736607b1a9f6df3c3a4b364515f70eed53`. Its package tree contains no existing Netflix/Prime recipes. ARM is not declared supported by this Chrome-based preview.

## Validation

The `Package validation` GitHub workflow uses a disposable Arch container. It builds without runtime dependency checking, installs with an explicit assumed Chrome dependency, and supplies a fake Chrome executable. It tests package ownership, desktop validation, migration backup/refusal/idempotence, retained profiles, actual package upgrade and removal. This proves package mechanics only; it does not prove browser dependency resolution or streaming.

Artifacts contain unsigned preview packages, SHA-256 digests, the package file list, generated `.SRCINFO` and namcap output. They are not production releases.

Local environment: Ubuntu 24.04 x86_64. An attempted local Arch bootstrap test could not run because chroot is not permitted. No live Omarchy version, Chrome, Widevine, account login, protected playback, window grouping, audio or fullscreen has been tested here. See CI for the result on each exact commit.
