# Verification

Reproduced on 2026-09-15: `bash tests/smoke.sh` exited 0. Tests cover syntax, app URL, dedicated profile, private profile-directory permissions, icon byte identity and desktop reference, paths with spaces, reinstall/removal, saved Prime and Netflix state preservation, relative XDG fallbacks, browser-flag rejection and uwsm delegation. Chrome and uwsm were stubs.

Platform: Linux-6.18.44-x86_64-with-glibc2.39; Bash 5.2.

Not run: real Omarchy, Chrome DRM/playback, window identity, fullscreen, sound, scaling, login redirects, sleep inhibition, desktop-file-validate or ShellCheck. The latter tools are unavailable here. No CI run is claimed.

Source lineage is recorded in README.md. SHA256SUMS identifies the delivered files.

## Pacman packaging development

The earlier local-installer results above are historical. New package validation and its explicit limits are documented in [PACKAGING.md](PACKAGING.md) and the per-commit GitHub workflow.
