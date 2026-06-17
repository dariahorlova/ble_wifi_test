# tm_wifi_connect

A low-dependency Flutter plugin to connect to WiFi networks by exact SSID or
SSID prefix, with optional WPA2/WPA3/WEP security. Built for Android 10+ (API
29) and iOS 13+ (connect APIs), iOS 11+ for the rest.

It mirrors the [`plugin_wifi_connect`](https://github.com/chenrilima/plugin_wifi_connect)
API under the class `TechmagicWifiConnect`, and additionally implements
`isEnabled`, `activateWifi` and `deactivateWifi` on **iOS** — the original
package supports those only on Android.

## API

```dart
import 'package:tm_wifi_connect/tm_wifi_connect.dart';

// radio state (Android + iOS)
final bool on = await TechmagicWifiConnect.isEnabled;
final bool enabled  = await TechmagicWifiConnect.activateWifi();   // Future<bool>
final bool disabled = await TechmagicWifiConnect.deactivateWifi(); // Future<bool>

// connect
await TechmagicWifiConnect.connect('MySSID', saveNetwork: true);
await TechmagicWifiConnect.connectByPrefix('MyPrefix');
await TechmagicWifiConnect.connectToSecureNetwork('MySSID', 'pass', saveNetwork: true);
await TechmagicWifiConnect.connectToSecureNetworkByPrefix('MyPrefix', 'pass');

// disconnect / state
await TechmagicWifiConnect.disconnect();
final String? ssid = await TechmagicWifiConnect.ssid;
```

## Toggling the WiFi radio

Neither modern Android (API 29+, where `WifiManager.setWifiEnabled` is a no-op)
nor iOS expose a public API to toggle the WiFi radio. So `activateWifi()` /
`deactivateWifi()`:

1. return immediately as `true` if the radio is already in the requested state;
2. otherwise open the system WiFi settings (Android Settings panel; iOS
   `App-Prefs:root=WIFI`);
3. poll `isEnabled` every 500ms for up to 30s, returning `true` once the target
   state is reached or `false` on timeout.

> **iOS caveats.** `App-Prefs:root=WIFI` is a private URL scheme and the
> `isEnabled` detection relies on the undocumented `awdl0` interface. Both are
> acceptable for internal / enterprise distribution but may be rejected on the
> App Store.

## Permissions

**Android** — declared by the plugin manifest (`ACCESS_WIFI_STATE`,
`CHANGE_WIFI_STATE`, `ACCESS_NETWORK_STATE`, `CHANGE_NETWORK_STATE`). Runtime
location/nearby-WiFi permissions are still the app's responsibility.

**iOS** — add the *Access WiFi Information* and *Hotspot Configuration*
capabilities to the app target, and (for `App-Prefs`) note the App Store caveat
above.
