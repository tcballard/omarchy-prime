# Changelog

## 0.1.0 - 2026-09-16

- First stable community release.
- Registers as **Prime** in the desktop app launcher with Prime Video's website icon.
- Opens Prime Video in a dedicated Chromium profile and normal browser window.
- Preserves login data across reinstall, package upgrade and removal.
- Provides user-local installation and an Arch package recipe with safe migration from local installs.
- Keeps Chromium sandboxing and GPU defaults enabled.
- Uses normal-window mode because protected playback passed there and failed with error 7031 in Chromium app mode on the target Omarchy system.
