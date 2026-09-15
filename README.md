# Prime Video for Omarchy

<img src="https://raw.githubusercontent.com/tcballard/omarchy-badges/75975e5b5bf75e7ede3764bcd2950046f7abfe2c/badges/v1/omarchy-app.svg" height="20" alt="Omarchy app">

An unofficial Prime Video launcher: its own Google Chrome window, official website icon and persistent login profile. The launcher opens Prime Video's website; Amazon provides the interface and player. No affiliation with Amazon or official Omarchy approval is implied.

**Linux playback is limited to standard definition**, according to [Amazon's system requirements](https://www.primevideo.com/help?nodeId=GUX9FYHU5D8LC9EJ). This launcher does not bypass that limit or provide offline downloads.

Development preview 0.1.0. Intended for Omarchy 4 on x86_64, with Google Chrome and an Amazon account with access to the content you want to watch. No installed Omarchy version or live Prime Video playback has been tested in the build environment.

## Install

```bash
git clone https://github.com/tcballard/omarchy-prime.git
cd omarchy-prime
bash install.sh
```

Search for **Prime Video (Unofficial)** in the app launcher. Install Google Chrome through Omarchy if the launcher reports it missing, then sign in directly on Prime Video. The installer needs no sudo and downloads nothing.

Direct launch from the repository:

```bash
bash omarchy-prime
```

## Updates, removal and data

Update your checkout and rerun `bash install.sh`. To roll back, run the installer from an earlier checkout. Both preserve login data.

```bash
bash uninstall.sh
```

Removal deletes only the launcher, its desktop entry and its icon. It preserves the Chrome profile at `$XDG_CONFIG_HOME/omarchy-prime/chrome` (default `~/.config/omarchy-prime/chrome`). That profile is separate from Netflix and your everyday Chrome profile. To erase it, close Prime Video and delete only that profile folder using your file manager.

Installed files live under `$XDG_DATA_HOME` (default `~/.local/share`): `omarchy-prime/omarchy-prime`, `applications/omarchy-prime.desktop`, and `icons/hicolor/128x128/apps/omarchy-prime.png`. Relative XDG values fall back to their defaults. No browser defaults, global shortcuts, autostart or Hyprland configuration are changed.

The launcher selects `google-chrome-stable` or `google-chrome` and delegates startup to `uwsm-app` when available in a Wayland session. Chrome's regular sandbox remains enabled. A separate browser profile is not an additional OS sandbox. Chrome is updated separately through your package manager.

## Verification

Run the portable smoke checks with `bash tests/smoke.sh`. They use temporary directories and a fake Chrome command, never your real account. See `VERIFICATION.md` for their scope.

Still to check on Omarchy: launcher/icon visibility, window grouping, Amazon login and redirects, protected playback, sound, subtitles, fullscreen, sleep inhibition, display scaling and remembered login after reopening. Amazon's Linux quality limit applies even when playback succeeds.

## Sources and licence

Based on the Netflix launcher from [tcballard/omarchy-netflix](https://github.com/tcballard/omarchy-netflix/commit/25abeaf986df9f37692d397ae63c83d8e7897788), originally following Omarchy's web-app pattern at revision `2fbac0c8e88eca704af1650ce721a494bd11a3d0`.

The unchanged `prime-video.png` is the 128×128 icon linked by [Prime Video](https://www.primevideo.com/), downloaded from [Amazon's asset server](https://m.media-amazon.com/images/G/01/digital/video/DVUI/favicons/favicon-128x128.png) on 2026-09-15. Amazon owns this artwork and its marks; they are excluded from the code's MIT licence. The launcher code is MIT licensed.
