import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/nfc_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../enums/transfer_status.dart';
import '../models/device_booklets.dart';
import '../models/device_config.dart';
import '../services/ble_service.dart';

class BLEWIFIRepository {
  BLEWIFIRepository(
    this._nfcService,
    this._bleService,
    this._wifiService,
    this._internetService,
  ) {
    _nfcService.setLogLevel(NFCLogLevel.debug);
    _bleService.setLogLevel(BLELogLevel.debug);
  }

  final NFCService _nfcService;
  final BLEService _bleService;
  final WifiService _wifiService;
  final InternetService _internetService;
  //BLE settings and commands
  static const String serviceUuid = 'ca23911f-cbb4-43ef-8509-87f7c9852d71';

  static const commandCharacteristicId = '26fd90a8-75a2-b5a2-774d-5fbd530c10a7';
  static const listenCharacteristicId = 'f55343e8-3030-41a7-b8f7-cb3e4cba8cf7';
  static const statusCharacteristicId = 'd9eec51c-7765-1b9a-5d44-f447a14f243f';

  static const _wifiEnableCommand = <int>[9, 4];
  static const _getContentCommand = <int>[9, 3];
  static const _setDateTimeCommand = <int>[9, 12];
  //WIFI settings
  static const wifiPassword = 'INFINIBOOK';
  static const wifiSsid = 'INFINIBOOK_';

  //... ble
  bool get isBLEDeviceConnected => _bleService.isBLEDeviceConnected;

  Future<(bool, String)> connectToDevice(BluetoothDevice device) =>
      _bleService.connectToDevice(device);

  /// disconnect connectedDevice
  Future<void> disconnectDeviceBLE() => _bleService.disconnect();

  /// scan for devices. we need in function that we can launch and get all it found
  /// as a list. we dont want to use a stream [FlutterBluePlus.scanResults] as is
  Future<List<ScanResult>?> scanForDevices({
    List<String> withServices = const [],
    Duration? timeout,
  }) =>
      _bleService.scanForDevices(withServices: withServices, timeout: timeout);

  Future<void> dispose() async {
    await disconnectDeviceBLE();
    await disconnectDeviceWifi();
  }

  Future<bool> turnOnWifi() async {
    try {
      developer.log('repo::turnOnWifi. sending BLE command to turn on wifi...');

      await _bleService.write(
        _bleService.getCharacteristicByUuidString(commandCharacteristicId),
        _wifiEnableCommand,
      );
      developer.log(
        'repo::turnOnWifi. sending BLE command to turn on wifi... done',
      );
      return true;
    } catch (e) {
      developer.log('repo::turnOnWifi. failed: $e');
    }
    return false;
  }

  Future<bool> setDateTime() async {
    try {
      developer.log('repo::setDateTime. sending DateTime.now()...');

      await _bleService.write(
        _bleService.getCharacteristicByUuidString(commandCharacteristicId),
        [
          ..._setDateTimeCommand,
          ...Uint8List(8)
            ..buffer.asByteData().setUint64(
              0,
              DateTime.now().millisecondsSinceEpoch ~/ 1000,
              Endian.little,
            ),
        ],
      );
      developer.log('repo::setDateTime. sending DateTime.now()... done');
      return true;
    } catch (e) {
      developer.log('repo::setDateTime. failed: $e');
    }
    return false;
  }

  Future<(bool, DeviceConfig?)> getConfig() async {
    try {
      late final Uint8List? statusResponse;
      while (true) {
        final response = await _bleService.read(
          _bleService.getCharacteristicByUuidString(statusCharacteristicId),
        );
        // reader can finally work with my request "_getContentCommand"
        if (response != null &&
            response[3] != TransferStatus.inProgress.value) {
          statusResponse = response;
          break;
        }
        // simple gap between tries. reader is busy. we have to retry
        await Future.delayed(const Duration(seconds: 1));
      }

      final (data, error) = await _bleService.writeWithResponse(
        _bleService.getCharacteristicByUuidString(commandCharacteristicId),
        _bleService.getCharacteristicByUuidString(listenCharacteristicId),
        _getContentCommand,
      );

      if (error != null || data == null) {
        return (false, null);
      }
      final contentJson =
          json.decode(utf8.decode(data.toList())) as Map<String, dynamic>;

      developer.log('repo::getConfig. got content: $contentJson');

      final resList = List<Map<String, dynamic>>.from(
        (contentJson['stories'] as List? ?? []).map(
          (e) => e as Map<String, dynamic>,
        ),
      );

      //todo: add possibleConnectedBookletIds. as i see for now,
      // parseInnerFolderNames() completely ignores all files and subfolders order.
      // so, we will never get a direstrories tree. we will get only variety
      // of folders without knowing a full tree structure.
      return (
        true,
        DeviceConfig.fromBytes(statusResponse).copyWith(
          readerBleId: _bleService.connectedDevice?.remoteId.str,
          remainingStorageMb: contentJson['remaining_mb'] as int? ?? 0,
          booklets: resList
              .map((story) => DeviceBooklets.fromJson(story))
              .toList(),
          possibleConnectedBookletIds: [],
        ),
      );
    } catch (e) {
      developer.log('repo::getConfig. failed: $e');
    }
    return (false, null);
  }

  //... wifi
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

  //... internet
  Future<bool> pingInternet() => _internetService.hasInternet();

  //... nfc
  Future<void> launchNFC(
    Future<void> Function({String? ndefData, String? error})? callback,
  ) => _nfcService.launch(callback);
}
