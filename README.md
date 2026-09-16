# Prime Video for Omarchy

<img src="https://raw.githubusercontent.com/tcballard/omarchy-badges/75975e5b5bf75e7ede3764bcd2950046f7abfe2c/badges/v1/omarchy-app.svg" height="20" alt="Omarchy app">

An unofficial Prime Video launcher: its own Chromium window, official website icon and persistent login profile. The launcher opens Prime Video's website; Amazon provides the interface and player. No affiliation with Amazon or official Omarchy approval is implied.

**Linux playback is limited to standard definition**, according to [Amazon's system requirements](https://www.primevideo.com/help?nodeId=GUX9FYHU5D8LC9EJ). This launcher does not bypass that limit or provide offline downloads.

Current release: **v0.1.0**. Intended for Omarchy 4 on x86_64, with Chromium and an Amazon account with access to the content you want to watch. Prime playback was verified on Chromium 151 in a normal window; Chromium app mode failed with Amazon error 7031 on the same machine and profile, so this launcher deliberately keeps the normal browser frame.

## Arch package

See [PACKAGING.md](PACKAGING.md) for package installation, migration, upgrade and removal instructions. This is an official release of this community project, not an Omarchy repository package or an Amazon product.

## Install locally

```bash
git clone https://github.com/tcballard/omarchy-prime.git
cd omarchy-prime
bash install.sh
```

Search for **Prime** in the app launcher. Install Chromium through Omarchy if the launcher reports it missing, then sign in directly on Prime Video. The installer needs no sudo and downloads nothing.

Direct launch from the repository:

```bash
bash omarchy-prime
```

## Updates, removal and data

Update your checkout and rerun `bash install.sh`. To roll back, run the installer from an earlier checkout. Both preserve login data.

```bash
bash uninstall.sh
```

Removal deletes only the launcher, its desktop entry and its icon. It preserves the Chromium profile at `$XDG_CONFIG_HOME/omarchy-prime/chrome` (default `~/.config/omarchy-prime/chrome`). The legacy `chrome` directory name is retained so upgrades preserve existing logins. That profile is separate from Netflix and your everyday Chromium profile. To erase it, close Prime Video and delete only that profile folder using your file manager.

Installed files live under `$XDG_DATA_HOME` (default `~/.local/share`): `omarchy-prime/omarchy-prime`, `applications/omarchy-prime.desktop`, and `icons/hicolor/128x128/apps/omarchy-prime.png`. Relative XDG values fall back to their defaults. No browser defaults, global shortcuts, autostart or Hyprland configuration are changed.

The launcher selects `chromium`, opens a normal dedicated window, and delegates startup to `uwsm-app` when available in a Wayland session. Chromium's regular sandbox remains enabled. A separate browser profile is not an additional OS sandbox. Chromium is updated separately through your package manager.

## Verification

Run the portable smoke checks with `bash tests/smoke.sh`. They use temporary directories and a fake Chromium command, never your real account. See `VERIFICATION.md` for their scope.

Still to check through the installed launcher: launcher/icon visibility, window grouping, sound, subtitles, fullscreen, sleep inhibition, display scaling and remembered login after reopening. Protected playback has passed in the underlying normal Chromium mode. Amazon's Linux quality limit applies even when playback succeeds.

## Sources and licence

Based on the Netflix launcher from [tcballard/omarchy-netflix](https://github.com/tcballard/omarchy-netflix/commit/25abeaf986df9f37692d397ae63c83d8e7897788), originally following Omarchy's web-app pattern at revision `2fbac0c8e88eca704af1650ce721a494bd11a3d0`.

The unchanged `prime-video.png` is the 128×128 icon linked by [Prime Video](https://www.primevideo.com/), downloaded from [Amazon's asset server](https://m.media-amazon.com/images/G/01/digital/video/DVUI/favicons/favicon-128x128.png) on 2026-09-15. Amazon owns this artwork and its marks; they are excluded from the code's MIT licence. The launcher code is MIT licensed.

The installer registers the app as **Prime** using a user-local `.desktop` entry. This is desktop launcher registration, not a pacman package. Existing installations get the updated name by updating the checkout and rerunning `bash install.sh`.
