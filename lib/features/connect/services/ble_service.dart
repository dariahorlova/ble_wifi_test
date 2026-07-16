import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEServiceResponseKeys {
  static const String bluetoothDisabled = 'bluetooth-disabled';
  static const String bleConnected = 'ble-connected';
  static const String bleFailedToConnect = 'ble-failed-to-connect';
  static const String bleNotConnected = 'ble-not-connected';
  static const String bleTimeoutError = 'ble-timeout-error';
}

enum BLELogLevel { debug, production }

class BLEService {
  factory BLEService() => _singleton;
  BLEService._();

  static final BLEService _singleton = BLEService._();

  /// device that is currently connected
  BluetoothDevice? connectedDevice;

  /// subscription for tracking connection state changes
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  bool _isConnected = false;

  final StreamController<bool> _connectionStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionStreamController.stream;

  /// getter to find out if the device is currently connected
  bool get isBLEDeviceConnected => _isConnected;

  BLELogLevel _logLevel = BLELogLevel.debug;
  void setLogLevel(BLELogLevel level) => _logLevel = level;

  /// all device's characteristics map
  final Map<Guid, BluetoothCharacteristic> _commands = {};

  /// helper function that returns characteristic by uuid string
  BluetoothCharacteristic? getCharacteristicByUuidString(String uuidString) =>
      _commands[Guid(uuidString)];

  /// service uuid that identifies the exact device type through all available ble devices
  List<String> _serviceUuid = [];

  /// set service uuid before start scanning to filter just wanted devices
  void _setServiceUuids(List<String> uuid) =>
      _serviceUuid = uuid.map((e) => e.toLowerCase()).toList();

  /// scan for wanted devices
  Future<List<ScanResult>?> scanForDevices({
    List<String> withServices = const [],
    Duration? timeout,
  }) async {
    _setServiceUuids(withServices);
    final serviceUuids = _serviceUuid.map((e) => Guid(e)).toList();
    _consoleOutput('BLEService:: bluetooth scanning...');
    if (FlutterBluePlus.isScanningNow) {
      _consoleOutput('BLEService:: already launched. skipping this time.');
      return null;
    }
    final isAvailable = await _isBluetoothEnabled();
    if (!isAvailable) {
      _consoleOutput(
        'BLEService:: your phone is deprecated. throw it away and buy new one with bluetooth.',
      );
      return null;
    }

    List<ScanResult> output = [];

    final subscription = FlutterBluePlus.scanResults.listen(
      (result) {
        output = result;
      },
      onError: (e, stackTrace) {
        _consoleOutput(e.toString());
      },
    );

    await FlutterBluePlus.startScan(
      withServices: serviceUuids,
      timeout: timeout,
    );

    await FlutterBluePlus.isScanning.where((e) => e == false).first;

    await subscription.cancel();
    _consoleOutput(
      'BLEService:: scanning was finished. found ${output.length} devices.',
    );
    return output;
  }

  /// connect to wanted BluetoothDevice
  Future<(bool, String)> connectToDevice(BluetoothDevice device) async {
    _consoleOutput(
      'BLEService:: trying to connect to device: ${device.remoteId.toString()}',
    );
    // what if we already connected to this device. just return true
    if (connectedDevice?.remoteId == device.remoteId && isBLEDeviceConnected) {
      return (true, BLEServiceResponseKeys.bleConnected);
    }

    _commands.clear();

    final isAvailable = await _isBluetoothEnabled();
    if (!isAvailable) {
      _consoleOutput('BLEService:: failed. bluetooth is disabled');
      return (false, BLEServiceResponseKeys.bluetoothDisabled);
    }
    if (isBLEDeviceConnected && connectedDevice!.remoteId != device.remoteId) {
      _consoleOutput(
        'BLEService:: another device is currently connected, so, disconnect it first',
      );
      await disconnect();
    }

    try {
      await _connectionStateSubscription?.cancel();

      await device.connect(timeout: const Duration(seconds: 10));

      connectedDevice = device;
      _connectionStateSubscription = connectedDevice?.connectionState.listen((
        state,
      ) {
        _isConnected = state == BluetoothConnectionState.connected;
        _connectionStreamController.add(_isConnected);

        if (!_isConnected) {
          _consoleOutput('BLEService:: device disconnected automatically.');
          connectedDevice = null;
          _commands.clear();
        }
      });

      _consoleOutput('BLEService:: successfully connected to device');

      if (await device.connectionState.first ==
          BluetoothConnectionState.connected) {
        if (Platform.isAndroid) {
          try {
            _consoleOutput('BLEService:: requesting MTU for Android...');
            final mtu = await device.requestMtu(512, timeout: 4);
            _consoleOutput('BLEService:: MTU set to $mtu');
          } catch (e) {
            _consoleOutput(
              'BLEService:: failed to set MTU: $e (it\'s okay, will use default)',
            );
          }
        }

        await _collectCharacteristics(device);

        return (true, BLEServiceResponseKeys.bleConnected);
      } else {
        return (false, BLEServiceResponseKeys.bleFailedToConnect);
      }
    } catch (e) {
      var message = e.toString();
      if (e is FlutterBluePlusException) {
        message =
            'Bluetooth problem: ${e.description?.toLowerCase() ?? message}. Maybe the device is off. Try to turn it on and repeat the action.';
      }
      _consoleOutput('BLEService:: $message');
      return (false, BLEServiceResponseKeys.bleFailedToConnect);
    }
  }

  /// collecting all characteristics from all needed services for future usage
  Future<void> _collectCharacteristics(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (var service in services) {
      if (!_serviceUuid.contains(service.uuid.str.toLowerCase())) {
        continue;
      }

      for (var characteristic in service.characteristics) {
        _commands[characteristic.uuid] = characteristic;
      }
    }
    _consoleOutput(
      'BLEService:: all characteristics are collected for future usage',
    );
  }

  /// local function to check if bluetooth is enabled and turn it on for android only
  Future<bool> _isBluetoothEnabled() async {
    if (await FlutterBluePlus.isSupported == false) {
      developer.log('BLEService:: bluetooth is not supported on this phone.');
      return false;
    }

    final completer = Completer<bool>();
    StreamSubscription<BluetoothAdapterState>? subscription;
    Timer? timeoutTimer;
    bool attemptToTurnOn = false;

    subscription = FlutterBluePlus.adapterState.listen((state) async {
      developer.log('BLEService:: current stream state is: $state');

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
          _consoleOutput(
            'BLEService:: bluetooth is off, trying to turn it on via Android...',
          );
          await FlutterBluePlus.turnOn();
        } catch (e) {
          _consoleOutput('BLEService:: failed to execute turnOn(): $e');
          timeoutTimer?.cancel();
          subscription?.cancel();
          if (!completer.isCompleted) completer.complete(false);
        }
      }
    });

    timeoutTimer = Timer(const Duration(seconds: 10), () {
      _consoleOutput(
        'BLEService:: timeout reached waiting for valid bluetooth state.',
      );
      subscription?.cancel();
      if (!completer.isCompleted) completer.complete(false);
    });

    final result = await completer.future;

    if (!result) {
      _consoleOutput(
        'BLEService:: user error. turn on the bluetooth manually.',
      );
    } else {
      _consoleOutput('BLEService:: bluetooth is on, we can proceed.');
    }

    return result;
  }

  Future<(Uint8List? data, String? errorMessage)> writeWithResponse(
    BluetoothCharacteristic? writeCharacteristic,
    BluetoothCharacteristic? listenCharacteristic,
    List<int> dataToWrite,
  ) async {
    if (!isBLEDeviceConnected) {
      return (null, BLEServiceResponseKeys.bleNotConnected);
    }

    StreamSubscription<List<int>>? subscription;
    final completer = Completer<(Uint8List?, String?)>();

    final List<int> accumulatedBytes = [];
    // we will use it to keep a full message length (with header)
    int? targetTotalLength;
    const int uselessHeaderSize = 4;

    try {
      await listenCharacteristic?.setNotifyValue(true);

      subscription = listenCharacteristic?.onValueReceived.listen((bytes) {
        accumulatedBytes.addAll(bytes);

        // first 4 bytes will tell us the full message size
        if (targetTotalLength == null &&
            accumulatedBytes.length >= uselessHeaderSize) {
          final headerBytes = Uint8List.fromList(
            accumulatedBytes.sublist(0, uselessHeaderSize),
          );
          // byte order is BigEndian. for LittleEndian use Endian.little
          final payloadLength = ByteData.sublistView(
            headerBytes,
          ).getUint32(0, Endian.little);

          targetTotalLength = payloadLength + uselessHeaderSize;
        }

        // let's check if we received the full message
        if (targetTotalLength != null &&
            accumulatedBytes.length >= targetTotalLength!) {
          if (!completer.isCompleted) {
            completer.complete((
              Uint8List.fromList(accumulatedBytes.sublist(4)),
              null,
            ));
          }
        }
      });

      await writeCharacteristic?.write(dataToWrite);

      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => (null, BLEServiceResponseKeys.bleTimeoutError),
      );
    } catch (e) {
      _consoleOutput('BLEService:: writeWithResponse error: $e');
      return (null, BLEServiceResponseKeys.bleTimeoutError);
    } finally {
      await listenCharacteristic?.setNotifyValue(false);
      await subscription?.cancel();
    }
  }

  /// simple write byte array [dataToWrite] to characteristic
  Future<bool> write(
    BluetoothCharacteristic? writeCharacteristic,
    List<int> dataToWrite,
  ) async {
    if (isBLEDeviceConnected) {
      await writeCharacteristic?.write(dataToWrite);
      return true;
    }
    return false;
  }

  /// simple read byte array from characteristic
  Future<Uint8List?> read(BluetoothCharacteristic? characteristic) async {
    if (characteristic != null && isBLEDeviceConnected) {
      final result = await characteristic.read();
      _consoleOutput(
        'BLEService:: read characteristic ${characteristic.uuid.str}. got [${_bytesAsString(result)}]',
      );
      return Uint8List.fromList(result);
    }
    return null;
  }

  String _bytesAsString(List<int> bytes) => bytes
      .map((byte) => '0x${byte.toRadixString(16).padLeft(2, '0')}')
      .join(' ');

  Future<void> disconnect() async {
    await _connectionStateSubscription?.cancel();
    await connectedDevice?.disconnect();
    connectedDevice = null;
    _commands.clear();
    _isConnected = false;
    _connectionStreamController.add(false);

    _consoleOutput('BLEService:: disconnected from device... done.');
  }

  void _consoleOutput(String message) {
    if (_logLevel == BLELogLevel.debug) {
      developer.log(message);
    }
  }
}
