# Changelog

## 0.0.1

- Initial release. Full `plugin_wifi_connect` API surface under
  `TechmagicWifiConnect`.
- `isEnabled`, `activateWifi`, `deactivateWifi` now implemented on **iOS** as
  well as Android. On platforms where the WiFi radio cannot be toggled
  programmatically (Android 10+ and iOS) these open the system WiFi settings and
  poll for up to 30s; `activateWifi`/`deactivateWifi` return `Future<bool>`.
