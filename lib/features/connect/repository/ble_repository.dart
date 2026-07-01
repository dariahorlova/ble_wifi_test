import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../enums/transfer_status.dart';
import '../models/device_booklets.dart';
import '../models/device_config.dart';
import '../services/ble_service.dart';

enum BLERepoLogLevel { debug, production }

class BleRepository {
  BleRepository(this._bleService) {
    _bleService.setLogLevel(BLELogLevel.debug);
  }

  final BLEService _bleService;

  static const String serviceUuid = 'ca23911f-cbb4-43ef-8509-87f7c9852d71';
  static const commandCharacteristicId = '26fd90a8-75a2-b5a2-774d-5fbd530c10a7';
  static const listenCharacteristicId = 'f55343e8-3030-41a7-b8f7-cb3e4cba8cf7';
  static const statusCharacteristicId = 'd9eec51c-7765-1b9a-5d44-f447a14f243f';
  static const _wifiEnableCommand = <int>[9, 4];
  static const _getContentCommand = <int>[9, 3];
  static const _factoryResetCommand = <int>[9, 11];
  static const _setDateTimeCommand = <int>[9, 12];
  static const _updateConfig = <int>[9, 14];
  static const _setRebootCommand = <int>[9, 15];

  /// for debugging purposes. by default [BLERepoLogLevel.debug]
  BLERepoLogLevel _logLevel = BLERepoLogLevel.debug;

  /// for debugging purposes. to turn off console logs use [BLERepoLogLevel.production]
  void setLogLevel(BLERepoLogLevel level) => _logLevel = level;

  /// is device connected getter. false if no device is connected
  bool get isBLEDeviceConnected => _bleService.isBLEDeviceConnected;

  /// stream of connection transitions. `false` means the device dropped the
  /// link (reboot/reset/wifi-enable/timeout). lets the cubit reconcile state.
  Stream<bool> get connectionStream => _bleService.connectionStream;

  /// connect to wanted BluetoothDevice
  /// returns tuple (isOk, message_key), where [isOk] means is connection successful or not
  /// [message_key] can be found in [BLEServiceResponseKeys]. we can use this keys for UI messages
  Future<(bool, String)> connectToDevice(BluetoothDevice device) =>
      _bleService.connectToDevice(device);

  /// disconnect connectedDevice
  Future<void> disconnect() => _bleService.disconnect();

  /// scan for devices. we need in function that we can launch and get all it found
  /// as a list. we dont want to use a stream [FlutterBluePlus.scanResults] as is
  Future<List<ScanResult>?> scanForDevices({
    List<String> withServices = const [],
    Duration? timeout,
  }) =>
      _bleService.scanForDevices(withServices: withServices, timeout: timeout);

  /// run task with error handling and logging
  /// [methodName] - name of method that will be logged
  /// [task] - task method with template result that will be executed
  /// [fallbackResult] - result that will be returned in case of error
  Future<T> _runBleTask<T>({
    required String methodName,
    required Future<T> Function() task,
    required T fallbackResult,
  }) async {
    try {
      _consoleOutput('repo::$methodName. Execution started...');
      final result = await task();
      _consoleOutput('repo::$methodName. Execution done.');
      return result;
    } catch (e) {
      _consoleOutput('repo::$methodName. failed: $e');
      return fallbackResult;
    }
  }

  /// console output. depends on [_logLevel]. and works only in debug mode
  void _consoleOutput(String message) {
    if (_logLevel == BLERepoLogLevel.debug) {
      developer.log(message);
    }
  }

  /// turn on wifi task. we send the command [_wifiEnableCommand]
  /// to device's [commandCharacteristicId] to turn on wifi.
  /// in case of success, the device breaks the ble connection and creates a
  /// wifi hotspot.
  Future<bool> turnOnWifi() async {
    return _runBleTask(
      methodName: 'turnOnWifi',
      fallbackResult: false,
      task: () async {
        await _bleService.write(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          _wifiEnableCommand,
        );
        return true;
      },
    );
  }

  /// set device's date and time.
  /// [timeBytes] is an 8 byte array - unix timestamp of date and time in seconds in little endian format
  /// we send the command [_setDateTimeCommand] to device's [commandCharacteristicId] to set date and time
  Future<bool> setDateTime() async {
    return _runBleTask(
      methodName: 'setDateTime',
      fallbackResult: false,
      task: () async {
        final timeBytes = Uint8List(8)
          ..buffer.asByteData().setUint64(
            0,
            DateTime.now().millisecondsSinceEpoch ~/ 1000,
            Endian.little,
          );

        await _bleService.write(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          [..._setDateTimeCommand, ...timeBytes],
        );
        return true;
      },
    );
  }

  /// reboot device. is case of success, the device reboots.
  /// device breaks ble connection. so, we have to manually reconect if needed after reboot
  /// we send the command [_setRebootCommand] to device's [commandCharacteristicId]
  Future<bool> setReboot() async {
    return _runBleTask(
      methodName: 'setReboot',
      fallbackResult: false,
      task: () async {
        await _bleService.write(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          _setRebootCommand,
        );
        return true;
      },
    );
  }

  /// factory reset device. is case of success, the device reboots.
  /// device breaks ble connection. so, we have to manually reconect if needed after reboot
  /// we send the command [_factoryResetCommand] to device's [commandCharacteristicId]
  Future<bool> factoryReset() async {
    return _runBleTask(
      methodName: 'factoryReset',
      fallbackResult: false,
      task: () async {
        await _bleService.write(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          _factoryResetCommand,
        );
        return true;
      },
    );
  }

  /// update config device. is case of success, the device reboots.
  /// if [resetSync] is true, resets sync time too.
  /// device breaks ble connection. so, we have to manually reconect if needed after reboot
  /// we send the command [_updateConfig] to device's [commandCharacteristicId]
  Future<bool> updateConfig(bool resetSync) async {
    return _runBleTask(
      methodName: 'updateConfig',
      fallbackResult: false,
      task: () async {
        await _bleService.write(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          [..._updateConfig, resetSync ? 1 : 0],
        );
        return true;
      },
    );
  }

  /// get config from device
  /// returns tuple (success, config) in case of success
  /// here we got device config data using ble connection.
  /// for details, see [DeviceConfig] class members.
  ///
  /// !!! NOTE: have no idea what for is [possibleConnectedBookletIds].
  /// cuz looking throug old code i see it contains just all device folders in simple list.
  /// not folder tree, where we can know subfolders and files inside, but just a flat list of device folders
  /// so, for now, [possibleConnectedBookletIds] - is empty list
  Future<(bool, DeviceConfig?)> getConfig() async {
    return _runBleTask(
      methodName: 'getConfig',
      fallbackResult: (false, null),
      task: () async {
        late final Uint8List? statusResponse;

        // 1. wait for device is ready
        while (true) {
          final response = await _bleService.read(
            _bleService.getCharacteristicByUuidString(statusCharacteristicId),
          );
          if (response != null &&
              response[3] != TransferStatus.inProgress.value) {
            statusResponse = response;
            break;
          }
          // simple gap between tries
          await Future.delayed(const Duration(seconds: 1));
        }

        // 2. getting content data
        final (data, error) = await _bleService.writeWithResponse(
          _bleService.getCharacteristicByUuidString(commandCharacteristicId),
          _bleService.getCharacteristicByUuidString(listenCharacteristicId),
          _getContentCommand,
        );

        if (error != null || data == null) {
          return (false, null);
        }

        // 3. convert to json
        final contentJson =
            json.decode(utf8.decode(data.toList())) as Map<String, dynamic>;
        _consoleOutput('repo::getConfig. got content: $contentJson');

        final resList = List<Map<String, dynamic>>.from(
          (contentJson['stories'] as List? ?? []).map(
            (e) => e as Map<String, dynamic>,
          ),
        );

        // 4. result
        //todo: add possibleConnectedBookletIds. as i see for now,
        // parseInnerFolderNames() completely ignores all files and subfolders order.
        // so, we will never get a direstrories tree. we will get only variety
        // of folders without knowing a full tree structure.
        final config = DeviceConfig.fromBytes(statusResponse).copyWith(
          readerBleId: _bleService.connectedDevice?.remoteId.str,
          remainingStorageMb: contentJson['remaining_mb'] as int? ?? 0,
          booklets: resList
              .map((story) => DeviceBooklet.fromJson(story))
              .toList(),
          possibleConnectedBookletIds: [],
        );

        return (true, config);
      },
    );
  }
}
