# Changelog

## 1.0.4

- Fixed the crash at the start of every transfer on some Android 8.x devices (e.g. MediaTek): the system throws while the foreground service looks up its not-yet-created notification channel, and the app is killed before any file can be sent or received. The notification channel is now created up front, before the service starts.

## 1.0.3

- Fixed a crash on finishing a transfer (sending, receiving files, and copying a received message): closing the receive/progress page could pop the root route and leave the navigator empty (black screen / force close). The `popUntil` navigation backport now falls back to the root route, matching refena_flutter 3.5.

## 1.0.2

- Added small-screen adaptation: on viewports whose shorter side is below 360 logical pixels (e.g. 308x240 hardware panels), the whole app is rendered on a virtual canvas and scaled down to fit, so all screens, buttons and menus stay fully visible and usable.
- The receive tab now uses a compact layout on short screens (small panels and landscape phones), fixing the logo/alias/button overflow.

## 1.0.1

- Fixed the startup crash on Android 5.x/6.x (`cannot locate symbol "getifaddrs"`): network interfaces are now enumerated via netlink on Android instead of `getifaddrs(3)`, which only exists since Android 7.0 (API 24).
- The `if-addrs` and `webrtc-util` Rust dependencies are patched locally under `support/patches/` to provide this.

## 1.0.0

- Initial release of LocalSend X, an independent fork of LocalSend.
- Lowers the minimum supported Android version to 5.0 (API 21); ships 32-bit, 64-bit and x86_64 APKs.
- Renamed the app to LocalSend X with a new package id (`io.github.jingrongx.localsend`), so it can be installed alongside the official LocalSend app.
- Added an in-app updater: automatic check on startup (optional), manual check in the settings tab, automatic download and install prompt.
- Releases are built and published automatically by GitHub Actions for every `v*` tag.
- Removed upstream donation, in-app purchase, and What's New features.
- Based on LocalSend 1.18.x (protocol v2, still compatible with the official app).
