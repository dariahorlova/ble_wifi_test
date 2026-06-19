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

  static const blePrefix = 'IB_';
  static const String serviceUuid = 'ca23911f-cbb4-43ef-8509-87f7c9852d71';
  static const commandCharacteristicId = '26fd90a8-75a2-b5a2-774d-5fbd530c10a7';
  static const listenCharacteristicId = 'f55343e8-3030-41a7-b8f7-cb3e4cba8cf7';
  static const statusCharacteristicId = 'd9eec51c-7765-1b9a-5d44-f447a14f243f';
  static const _wifiEnableCommand = <int>[9, 4];
  static const _getContentCommand = <int>[9, 3];
  static const _factoryResetCommand = <int>[9, 11];
  static const _setDateTimeCommand = <int>[9, 12];
  static const _setRebootCommand = <int>[9, 15];

  BLERepoLogLevel _logLevel = BLERepoLogLevel.debug;
  void setLogLevel(BLERepoLogLevel level) => _logLevel = level;

  bool get isBLEDeviceConnected => _bleService.isBLEDeviceConnected;

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

  void _consoleOutput(String message) {
    if (_logLevel == BLERepoLogLevel.debug) {
      developer.log(message);
    }
  }

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
              .map((story) => DeviceBooklets.fromJson(story))
              .toList(),
          possibleConnectedBookletIds: [],
        );

        return (true, config);
      },
    );
  }
}
