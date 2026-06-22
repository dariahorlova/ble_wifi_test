# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                              # install deps
flutter run                                  # run on connected device (BLE/WiFi/NFC need real hardware, not simulator)
flutter analyze                              # lint (flutter_lints via analysis_options.yaml)
flutter test                                 # run tests (no test/ dir exists yet)

# Codegen — freezed + json_serializable. Re-run after editing any @freezed / @JsonKey class.
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # continuous
```

`*.freezed.dart` and `*.g.dart` files are generated — never edit by hand; edit the source class and regenerate.

## Architecture

Flutter app demonstrating a **BLE-controlled reader device** flow: discover a device over Bluetooth LE, read/write its config, set its clock, and optionally command it to start a WiFi hotspot for a **BLE → WiFi handoff** (join the hotspot, exchange data, leave). NFC tags trigger an autoconnect+config sequence.

Single feature, layered. Dependencies flow downward; constructed once in `main.dart` and injected via `BlocProvider`:

```
UI (lib/main_screen.dart)
  → BleWifiCubit          state + orchestration
    ├→ BleRepository       BLE/GATT protocol: commands, config read, datetime, reboot, reset
    │    → BLEService       flutter_blue_plus singleton: scan/connect/read/write GATT chars
    └→ CommonRepository    non-BLE coordination
         → NFCService       nfc_manager singleton: tag polling + retry loop
         → WifiService      tm_wifi_connect singleton: join/leave networks
         → InternetService  http ping to detect connectivity
```

The cubit holds **two** repositories: `BleRepository` (passed as `_bleRepository`) and `CommonRepository` (passed as `repository`). This split is recent — keep BLE/GATT concerns in `BleRepository`, everything else (wifi, nfc, internet) in `CommonRepository`.

- **`BleWifiCubit`** (`lib/features/connect/cubit/`) — single source of truth. State is freezed (`ble_wifi_state.dart`): `status` enum, `currentDeviceIndex`, `isWifiConnected`, `hintText`, `devices`, `deviceConfig`. UI hints are transient — `_temporaryHint` emits a message then clears it after a delay. Key methods: `searchBLE`, `connectToDeviceBLEByIndex`, `getDeviceConfigByBle`, `updateDateTimeOnBle`, `makeMagic`, `launchNFC`.
- **`BleRepository`** (`repository/ble_repository.dart`) — all BLE protocol constants and command logic. Service/characteristic UUIDs (`serviceUuid`, `commandCharacteristicId`, `listenCharacteristicId`, `statusCharacteristicId`) and command byte arrays (all `[9, x]`): wifi-enable `[9,4]`, get-content `[9,3]`, factory-reset `[9,11]`, set-datetime `[9,12]`, update-config `[9,14]`, reboot `[9,15]`. Every command runs through `_runBleTask` (logging + try/catch + fallback). `blePrefix = 'IB_'`.
- **`CommonRepository`** (`repository/common_repository.dart`) — WiFi settings live here: `wifiSsid = 'INFINIBOOK_'`, `wifiPassword = 'INFINIBOOK'`.
- **Services** (`services/`) — `BLEService`, `WifiService`, `NFCService` are singletons (factory + private ctor + static instance). Each has its own `LogLevel` enum + `setLogLevel`.
- **Models** (`models/`) — `DeviceConfig` (freezed; `fromBytes` parses the status-characteristic byte layout: firmware bytes 0–2, transfer-status byte 3, readerId bytes 4–9 hex, battery byte 10, currentStoryKey bytes 11–26) and `DeviceBooklets` (freezed + json). `TransferStatus` enum (`enums/`, values idle/inProgress/success/failed = 0–3).

### BLE GATT protocol detail

- **Simple commands** (`turnOnWifi`, `setDateTime`, `setReboot`, `factoryReset`, `updateConfig`) — fire-and-forget `write` of the command bytes to `commandCharacteristicId`. Reboot/reset/updateConfig/wifi-enable all cause the device to **drop the BLE connection**.
- **`getConfig`** — multi-step: (1) poll `statusCharacteristicId` until byte 3 ≠ `inProgress`; (2) `writeWithResponse(commandChar, listenChar, [9,3])` to fetch content. `writeWithResponse` reassembles a notify-based response: first 4 bytes are a little-endian `uint32` payload length (a header that is then stripped); it accumulates `onValueReceived` chunks until the full payload arrives, 10 s timeout. Returns parsed `DeviceConfig` merged with JSON content (`stories` → booklets, `remaining_mb`).
- `BLEService` requests MTU 512 on Android after connect; collects all characteristics of the matching service into a `Guid → BluetoothCharacteristic` map (`getCharacteristicByUuidString`).

### The `makeMagic` sequence (cubit) — WiFi handoff

1. BLE write `[9,4]` → device turns on its WiFi hotspot
2. join the device's WiFi (SSID = `INFINIBOOK_` + uuid extracted from `advName` after `IB_`, password `INFINIBOOK`); disconnect BLE
3. while joined, phone has **no internet** (device hotspot has no uplink) — the window to exchange data; current code just polls `pingInternet` 5×
4. leave WiFi, loop `pingInternet` until normal internet returns

### NFC flow (`_nfcCallback`)

On tag read, `NFCService` extracts the `reader_id` query param from the tag's URI. Cubit prefixes it with `IB_` to form the BLE advName, then: `_autoconnectToDeviceBLE` (scan + connect) → `updateDateTimeOnBle` → `getDeviceConfigByBle`. (`makeMagic` is currently commented out of this path.) `NFCService` retries up to 10× with 1 s gaps on technical failures.

### Device identity convention

BLE advertised name = `IB_` + reader id. WiFi SSID = `INFINIBOOK_` + that same id. NFC tag URI's `reader_id` param yields the reader id.

## Platform notes

- BLE/WiFi/NFC require a physical device. iOS WiFi/BLE/NFC need entitlements + Info.plist usage strings; Android needs runtime location/bluetooth/nearby permissions. `BLEService` auto-turns-on Bluetooth on Android only.
- WiFi join uses the **local path plugin** `plugins/tm_wifi_connect` (`TechmagicWifiConnect`). iOS programmatic WiFi join is limited and may require user confirmation. `WifiService` retries the join 5×.
- `InternetService.hasInternet` pings an app-engine endpoint and treats **HTTP 401 as "internet OK"** (expected unauthenticated response); anything else = no internet.
- Comments in the codebase are mixed Ukrainian/English and sometimes jokey; not load-bearing.
