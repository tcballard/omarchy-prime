# Verification

Reproduced on 2026-09-16: `bash tests/smoke.sh` exited 0. Tests cover the reported `0.1.0` version, syntax, normal-window mode (and absence of app mode), fixed URL, dedicated profile, private profile-directory permissions, icon byte identity and desktop reference, paths with spaces, reinstall/removal, saved Prime and Netflix state preservation, relative XDG fallbacks, browser-flag rejection and uwsm delegation. Chromium and uwsm were stubs.

Platform: Linux-6.18.44-x86_64-with-glibc2.39; Bash 5.2.

Target-machine evidence on 2026-09-16: Omarchy, Chromium 151.0.7922.173, Widevine 4.10.3050.0; protected Prime playback succeeded in a normal Chromium window and failed with error 7031 in app mode using the same fresh profile. Still to check through the installed launcher: window identity, fullscreen, sound, scaling, login redirects and sleep inhibition.

Source lineage is recorded in README.md. SHA256SUMS identifies the delivered files.

## Pacman packaging development

The earlier local-installer results above are historical. New package validation and its explicit limits are documented in [PACKAGING.md](PACKAGING.md) and the per-commit GitHub workflow.
