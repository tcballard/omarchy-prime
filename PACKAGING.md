# Pacman packaging preview

Status: development packaging, version `0.1.0pre1-1`. No official Omarchy inclusion or vendor endorsement. The existing user-local installer remains available.

## Build and install on x86_64 Arch / Omarchy

Requires `base-devel`, `git`, and Chromium. The package depends on Arch's `chromium` package; it does not install a browser from an arbitrary source. On the target Omarchy machine, Chromium 151 reported Widevine 4.10.3050.0 and Prime protected playback succeeded in a normal tab. The same profile failed with error 7031 in Chromium app mode, so the launcher deliberately uses `--new-window` instead of `--app`.

From this checkout, as your ordinary user:

```bash
cd packaging
makepkg -f
sudo pacman -U ./omarchy-prime-0.1.0pre1-1-x86_64.pkg.tar.zst
omarchy-prime-migrate-local
```

The migration command runs without sudo, after the package is installed. It backs up the previous local desktop entry, matching helper and matching icon under `$XDG_DATA_HOME/omarchy-app-migration/` (default `~/.local/share/omarchy-app-migration/`). It refuses modified helpers/icons and symlinked files. It can be rerun. It never moves or removes the browser profile. If a local file has been customised, review it manually. The package itself has no installation or removal hooks that edit home directories.

Both launch methods use the existing `$XDG_CONFIG_HOME/omarchy-prime/chrome` profile. The legacy directory name preserves existing login state. Close the app before upgrading. To update, install a newer package with `pacman -U`; automatic updates require a configured repository publishing this package. To remove:

```bash
sudo pacman -R omarchy-prime
```

Removal preserves login data and migration backups. To return to the local installation, remove the package and rerun `bash install.sh` from the repository root. Avoid running the local installer while the package is installed, because its desktop entry overrides the system entry.

## Sources and release route

The recipe pins the Chromium normal-window launcher source to commit `383a36eb9d87331207ffeb3d9bc0f68a33d53350` and a SHA-256 digest. Desktop and migration files are separately checksummed. It installs only `/usr/bin`, `/usr/share/applications`, icons and licence notices. Social preview artwork is excluded.

`packaging/.omarchy/package.json` is prepared as local-source metadata for a future `pkgbuilds/omarchy-prime/` contribution. No upstream watch is declared yet: this is a commit-pinned development preview, not a tagged supported release. Before submission: complete installed-launcher desktop acceptance, review icon redistribution, then tag a release and pin its archive/digest with a release watch.

Official packaging implementation inspected at `omacom/omarchy-pkgs@5fe236736607b1a9f6df3c3a4b364515f70eed53`. Its package tree contains no existing Netflix/Prime recipes. ARM is not declared supported by this preview.

## Validation

The `Package validation` GitHub workflow uses a disposable Arch container. It builds without runtime dependency checking, installs with an explicit assumed Chromium dependency, and supplies a fake Chromium executable. It tests package ownership, desktop validation, normal-window arguments, migration backup/refusal/idempotence, retained profiles, actual package upgrade and removal. This proves package mechanics only; live playback evidence comes from the target Omarchy machine.

Artifacts contain unsigned preview packages, SHA-256 digests, the package file list, generated `.SRCINFO` and namcap output. They are not production releases.

Target acceptance evidence: Omarchy, Chromium 151.0.7922.173, Widevine 4.10.3050.0; Prime playback succeeded in normal-window mode and failed in app mode. Installed launcher window grouping, audio, subtitles and fullscreen remain to be checked. See CI for package mechanics on each exact commit.

### Reproduced package lifecycle evidence

On 2026-09-15, Arch CI successfully built, installed, migrated, upgraded from revision 1 to 2, and removed the actual package, preserving login and unrelated-app markers. The fake browser verified the fixed URL and existing profile path. Modified helpers were refused and repeated migration was harmless. ShellCheck and desktop-file-validate passed. The current revision additionally asserts normal-window mode and rejects app mode.

The first lifecycle run reported an obsolete custom licence identifier from namcap; the recipe now uses `LicenseRef-Proprietary-Artwork` and CI fails on namcap errors. Expected warnings remain for restricting architecture-independent scripts to x86_64 and for runtime shell dependencies that static analysis cannot reliably identify. Final evidence is tied to the exact commit shown by the PR's checks.
