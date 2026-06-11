import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../utils/helper_functions.dart';

class BLEService {
  factory BLEService() => _singleton;
  BLEService._();

  static final BLEService _singleton = BLEService._();

  Future<String> writeWithResponse(
    BluetoothCharacteristic? writeCharacteristic,
    BluetoothCharacteristic? listenCharacteristic,
    List<int> dataToWrite,
  ) async {
    StreamSubscription<List<int>>? subscription;
    final completer = Completer<String>();
    await listenCharacteristic?.setNotifyValue(true);
    subscription = listenCharacteristic?.onValueReceived.listen((bytes) async {
      developer.log(
        'writeWithRresponse. notify from device [${bytesAsString(Uint8List.fromList(bytes))}] to characteristic ${listenCharacteristic.uuid.str}',
      );
      await subscription?.cancel();
      // for example, if we got 0x00 - this means all is ok
      // if we got 0x01, 0x02 or something else, we have to modify this code to text error and show it to user
      // for example, if we got 0x01 - this means "can't do this operation cuz of low battery", etc.
      completer.complete(bytesAsString(Uint8List.fromList(bytes)));
    });

    await writeCharacteristic?.write(dataToWrite);

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () async {
        await subscription?.cancel();
        return 'timeout-error';
      },
    );
  }

  Future<void> write(
    BluetoothCharacteristic? writeCharacteristic,
    List<int> dataToWrite,
  ) async {
    await writeCharacteristic?.write(dataToWrite);
  }
}
