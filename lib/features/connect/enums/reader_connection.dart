/// How the app is currently talking to a reader device.
///
/// Only one device is ever active at a time and only over a single transport:
/// - [none] — discovered/known, but not connected
/// - [ble]  — connected over Bluetooth LE (config, datetime, commands)
/// - [wifi] — joined the device's WiFi hotspot (BLE link is dropped during this)
enum ReaderConnection { none, ble, wifi }
