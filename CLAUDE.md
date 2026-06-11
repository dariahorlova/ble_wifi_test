# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                              # install deps
flutter run                                  # run on connected device (BLE/WiFi/NFC need real hardware, not simulator)
flutter analyze                              # lint (flutter_lints via analysis_options.yaml)
flutter test                                 # run all tests
flutter test test/foo_test.dart             # run single test file
flutter test --plain-name "name"            # run single test by name

# Codegen — freezed state classes. Re-run after editing any @freezed class.
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # continuous
```

`*.freezed.dart` files are generated — never edit by hand; edit the source `@freezed` class and regenerate.

## Architecture

Flutter app demonstrating a **BLE → WiFi handoff** flow: discover a device over Bluetooth LE, command it (over BLE) to start a WiFi hotspot, then disconnect BLE and join that hotspot over WiFi. NFC tags can trigger autoconnect.

Single feature, layered. Dependencies flow downward; constructed once in `main.dart` and injected via `BlocProvider`:

```
UI (main_screen.dart)
  → BleWifiCubit          state + orchestration (the full "makeMagic" sequence)
    → BLEWIFIRepository   coordinates the three services, owns connected device + characteristics
      → BLEService        flutter_blue_plus read/write to GATT characteristics
      → WifiService       plugin_wifi_connect join/leave networks
      → InternetService   http ping to detect connectivity
```

- **`BleWifiCubit`** (`lib/features/connect/cubit/`) — single source of truth. State is freezed (`ble_wifi_state.dart`): `status` enum, `currentDeviceIndex`, `isWifiConnected`, `hintText`, `devices`. UI hints are transient — `_temporaryHint` emits a message then clears it after a delay.
- **`BLEWIFIRepository`** (`repository/`) — holds the connected `BluetoothDevice` and a `Guid → BluetoothCharacteristic` map built at connect time via `_collectCharacteristics`. All hardcoded protocol constants live here: `serviceUuid`, `commandCharacteristicId`, `wifiSsid`/`wifiPassword`, and the `turnOnWifi` command bytes `[9, 4]`.
- **Services** (`services/`) — `BLEService` and `WifiService` are singletons (private ctor + static instance). Stateless wrappers over plugins.

### The `makeMagic` sequence (cubit) — core flow

1. BLE write command bytes to device → device turns on its WiFi hotspot
2. disconnect BLE
3. join the device's WiFi network (SSID = `INFINIBOOK_` + device uuid, password `INFINIBOOK`)
4. while joined, phone has **no internet** (device hotspot has no uplink) — this is the window to exchange data with the device over its hotspot; current code just polls `pingInternet` 5×
5. leave WiFi, wait for normal internet to return

### Device identity convention

BLE advertised name = `IB_` + reader id. WiFi SSID = `INFINIBOOK_` + that same id. NFC tag carries a URI whose `reader_id` query param yields the BLE name (`IB_<reader_id>`), used by `_autoconnectToDeviceBLE`.

## Platform notes

- BLE/WiFi/NFC require a physical device. iOS WiFi/BLE/NFC need entitlements + Info.plist usage strings; Android needs runtime location/bluetooth/nearby permissions.
- `WifiService` uses `plugin_wifi_connect` — iOS programmatic WiFi join is limited and may require user confirmation.
- Comments in the codebase are mixed Ukrainian/English and sometimes jokey; not load-bearing.
