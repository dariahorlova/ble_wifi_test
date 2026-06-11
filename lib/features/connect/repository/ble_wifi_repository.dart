import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../services/ble_service.dart';

class BLEWIFIRepository {
  BLEWIFIRepository(this._bleService, this._wifiService, this._internetService);

  final BLEService _bleService;
  final WifiService _wifiService;
  final InternetService _internetService;
  //BLE settings
  static const String serviceUuid = 'ca23911f-cbb4-43ef-8509-87f7c9852d71';
  static const commandCharacteristicId = '26fd90a8-75a2-b5a2-774d-5fbd530c10a7';
  //WIFI settings
  static const wifiPassword = 'INFINIBOOK';
  static const wifiSsid = 'INFINIBOOK_';

  BluetoothDevice? connectedDevice;
  bool get isBLEDeviceConnected => connectedDevice != null;
  final Map<Guid, BluetoothCharacteristic> _commands = {};
  BluetoothCharacteristic? _getCharacteristicByUuidString(String uuidString) =>
      _commands[Guid(uuidString)];

  Future<(bool, String)> connectToDevice(BluetoothDevice device) async {
    developer.log(
      'repo::connectToDevice. trying to connect to device: ${device.remoteId.toString()}',
    );
    _commands.clear();

    final isAvailable = await _isBluetoothEnabled();
    if (!isAvailable) {
      developer.log('repo::connectToDevice. failed. bluetooth is disabled');
      return (false, 'bluetooth is disabled');
    }
    if (connectedDevice != null &&
        connectedDevice!.remoteId != device.remoteId) {
      developer.log(
        'repo::connectToDevice. another device is currently connected, so, disconnect it first',
      );
      await disconnectDeviceBLE();
    }

    try {
      await device.connect(timeout: const Duration(seconds: 10));
      developer.log('repo::connectToDevice. successfully connected to device');
      if (await device.connectionState.first ==
          BluetoothConnectionState.connected) {
        await _collectCharacteristics(device);
        connectedDevice = device;

        connectedDevice?.connectionState.listen((state) async {
          if (state == BluetoothConnectionState.disconnected) {
            if (state == BluetoothConnectionState.disconnected) {
              connectedDevice = null;
            }
          }
        });

        return (true, 'BLE device is connected');
      } else {
        return (false, 'Cannot connect to BLE device');
      }
    } catch (e) {
      var message = e.toString();
      if (e is FlutterBluePlusException) {
        message =
            'Bluetooth problem: ${e.description?.toLowerCase() ?? message}. Maybe the device is off. Try to turn it on and repeat the action.';
      }
      developer.log('repo::connectToDevice. $message');
      return (false, message);
    }
  }

  Future<void> _collectCharacteristics(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (var service in services) {
      //skip garbage. we need only device with our BLE service
      if (service.uuid.str != serviceUuid) {
        continue;
      }

      for (var characteristic in service.characteristics) {
        _commands[characteristic.uuid] = characteristic;
      }
    }
    developer.log(
      'repo::_collectCharacteristics. all characteristics are collected for future usage',
    );
  }

  /// disconnect connectedDevice
  Future<void> disconnectDeviceBLE() async {
    await connectedDevice?.disconnect();
    connectedDevice = null;
    developer.log(
      'repo::disconnectDeviceBLE. disconnected from device... done.',
    );
  }

  /// scan for devices. we need in function that we can launch and get all it found
  /// as a list. we dont want to use a stream [FlutterBluePlus.scanResults] as is
  Future<List<ScanResult>?> scanForDevices({
    List<Guid> withServices = const [],
    Duration? timeout,
  }) async {
    developer.log('repo::scanForDevices. bluetooth scanning...');
    if (FlutterBluePlus.isScanningNow) {
      developer.log(
        'repo::scanForDevices. already launched. skipping this time.',
      );
      return null;
    }
    final isAvailable = await _isBluetoothEnabled();
    if (!isAvailable) {
      developer.log(
        'repo::scanForDevices. your phone is deprecated. throw it away and buy new one with bluetooth.',
      );
      return null;
    }

    List<ScanResult> output = [];

    final subscription = FlutterBluePlus.scanResults.listen(
      (result) {
        output = result;
      },
      onError: (e, stackTrace) {
        developer.log(e.toString());
      },
    );

    await FlutterBluePlus.startScan(
      withServices: withServices,
      timeout: timeout,
    );

    await FlutterBluePlus.isScanning.where((e) => e == false).first;

    await subscription.cancel();
    developer.log(
      'repo::scanForDevices. scanning was finished. something was probably found',
    );
    return output;
  }

  /// local function to check if bluetooth is enabled and turn it on for android only
  Future<bool> _isBluetoothEnabled() async {
    if (await FlutterBluePlus.isSupported == false) {
      developer.log(
        'repo::_isBluetoothEnabled. bluetooth is not supported on this phone.',
      );
      return false;
    }

    final completer = Completer<bool>();
    StreamSubscription<BluetoothAdapterState>? subscription;
    Timer? timeoutTimer;
    bool attemptToTurnOn = false;

    subscription = FlutterBluePlus.adapterState.listen((state) async {
      developer.log(
        'repo::_isBluetoothEnabled. current stream state is: $state',
      );

      if (state == BluetoothAdapterState.on) {
        timeoutTimer?.cancel();
        subscription?.cancel();
        if (!completer.isCompleted) completer.complete(true);
        return;
      }

      if (state == BluetoothAdapterState.unauthorized ||
          state == BluetoothAdapterState.turningOff) {
        timeoutTimer?.cancel();
        subscription?.cancel();
        if (!completer.isCompleted) completer.complete(false);
        return;
      }

      if (state == BluetoothAdapterState.off &&
          Platform.isAndroid &&
          !attemptToTurnOn) {
        attemptToTurnOn = true;
        try {
          developer.log(
            'repo::_isBluetoothEnabled. bluetooth is off, trying to turn it on via Android...',
          );
          await FlutterBluePlus.turnOn();
        } catch (e) {
          developer.log(
            'repo::_isBluetoothEnabled. failed to execute turnOn(): $e',
          );
          timeoutTimer?.cancel();
          subscription?.cancel();
          if (!completer.isCompleted) completer.complete(false);
        }
      }

      // if "unknown" just wait it will be changed soon
    });

    // just a global timer for turning on bluetooth. if timeout reached, we return false
    timeoutTimer = Timer(const Duration(seconds: 10), () {
      developer.log(
        'repo::_isBluetoothEnabled. Timeout reached waiting for valid bluetooth state.',
      );
      subscription?.cancel();
      if (!completer.isCompleted) completer.complete(false);
    });

    final result = await completer.future;

    if (!result) {
      developer.log(
        'repo::_isBluetoothEnabled. user error. turn on the bluetooth manually.',
      );
    } else {
      developer.log(
        'repo::_isBluetoothEnabled. yeah, it is on, we can proceed.',
      );
    }

    return result;
  }

  Future<void> dispose() async {
    await disconnectDeviceBLE();
    await disconnectDeviceWifi();
  }

  Future<bool> turnOnWifi() async {
    try {
      developer.log('repo::turnOnWifi. sending BLE command to turn on wifi...');

      final commandBytes = [9, 4];
      await _bleService.write(
        _getCharacteristicByUuidString(commandCharacteristicId),
        commandBytes,
      );
      developer.log(
        'repo::turnOnWifi. sending BLE command to turn on wifi... done',
      );
      return true;
    } catch (e) {
      developer.log('repo::turnOnWifi. failed to turn on wifi: $e');
    }
    return false;
  }

  Future<bool> connectToDeviceWifi(String uuid) async {
    try {
      developer.log(
        'repo::connectToDeviceWifi. connecting to device wifi...  $wifiSsid$uuid :: $wifiPassword',
      );
      final res = await _wifiService.connectToDeviceWifi(
        '$wifiSsid$uuid',
        wifiPassword,
      );
      developer.log(
        'repo::connectToDeviceWifi. connecting to device wifi... $res',
      );
      return res;
    } catch (e) {
      developer.log('repo::connectToDeviceWifi. failed to connect on wifi: $e');
    }
    return false;
  }

  Future<String?> get currentWifiSsid => _wifiService.currentWifiSsid;

  Future<bool> disconnectDeviceWifi() => _wifiService.disconnect();

  Future<bool> connectToWifi(String ssid) => _wifiService.connectToWifi(ssid);

  Future<bool> pingInternet() => _internetService.hasInternet();
}
