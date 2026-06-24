import 'dart:developer' as developer;

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

enum NFCLogLevel { debug, production }

class NFCService {
  factory NFCService() => _singleton;
  NFCService._();

  static final NFCService _singleton = NFCService._();
  NFCLogLevel _logLevel = NFCLogLevel.debug;
  void setLogLevel(NFCLogLevel level) => _logLevel = level;

  int _nfcRetryCount = 0;
  static const int _maxNfcRetries = 10;
  static const gapBetweenNfcAttempts = Duration(milliseconds: 1000);
  bool _isProcessingTag = false;

  /// that's a callback parent function. it takes ndef data as a string parameter
  Future<void> Function({String? ndefData, String? error})? _callback;

  Future<void> launch(
    Future<void> Function({String? ndefData, String? error})? callback,
  ) async {
    final nfcAvailability = await NfcManager.instance.checkAvailability();
    final isNfcAvailable = nfcAvailability == NfcAvailability.enabled;

    _consoleOutput('NFCService:: NFC availability: $isNfcAvailable');
    if (!isNfcAvailable) return;

    _callback = callback;

    await _stopNFCSession();

    _nfcRetryCount = 0;
    _startSessionInternal();
  }

  void _startSessionInternal() async {
    _consoleOutput(
      'NFCService:: starting session... attempt: ${_nfcRetryCount + 1}',
    );

    _isProcessingTag = false;

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      invalidateAfterFirstReadIos: true,
      alertMessageIos: "Touch and hold iPhone until sound is heard",
      onDiscovered: _onTagDiscovered,
      onSessionErrorIos: (error) async {
        _consoleOutput('NFCService:: iOS session error: ${error.code.name}');
        if (error.code ==
            NfcReaderErrorCodeIos.readerSessionInvalidationErrorUserCanceled) {
          _consoleOutput('NFCService:: user closed the NFC dialog');
          _nfcRetryCount = 0;
          return;
        }

        _consoleOutput(
          'NFCService:: technical error detected, triggering retry log...',
        );
        _handleNfcFailure('iOS Error: ${error.toString()}');
      },
    );
  }

  Future<void> _onTagDiscovered(NfcTag tag) async {
    if (_isProcessingTag) return;
    _isProcessingTag = true;

    _consoleOutput('NFCService:: NFC tag found...');

    try {
      final ndef = Ndef.from(tag);
      if (ndef == null || ndef.cachedMessage == null) {
        _consoleOutput('NFCService:: tag is not NDEF or empty.');
        _handleNfcFailure('ndef or cachedMessage is null');
        return;
      }

      final records = ndef.cachedMessage!.records;
      if (records.isEmpty) {
        _consoleOutput('NFCService:: records are empty.');
        _isProcessingTag = false;
        return;
      }

      final uri = Uri.tryParse(
        String.fromCharCodes(records[0].payload.sublist(1)),
      ); // 1st byte is type in our case it 0x04 and means "https://"
      _consoleOutput('NFCService:: uri: $uri');
      _nfcRetryCount = 0;

      // launch external method from parrent side
      _callback?.call(ndefData: uri?.queryParameters['reader_id'] ?? '');
    } catch (e) {
      _consoleOutput('NFCService:: catch block triggered: $e');
      _handleNfcFailure(e.toString());
    } finally {
      _isProcessingTag = false;
    }
  }

  void _handleNfcFailure(String reason) async {
    if (_nfcRetryCount < _maxNfcRetries) {
      _nfcRetryCount++;
      _consoleOutput(
        'NFCService:: retrying... attempt $_nfcRetryCount. reason: $reason',
      );

      await _stopNFCSession();

      // pause between attempts
      await Future.delayed(gapBetweenNfcAttempts);

      _startSessionInternal();
    } else {
      _consoleOutput('NFCService:: max retries reached.');
      _nfcRetryCount = 0;
      await _stopNFCSession();

      //here we can notify UI that all NFC attempts failed
      _callback?.call(error: 'all NFC attempts failed');
    }
  }

  Future<void> _stopNFCSession() async {
    try {
      _consoleOutput('NFCService:: NFC session can be stopped...');
      await NfcManager.instance.stopSession();
    } catch (e) {
      _consoleOutput('NFCService:: there is no previous NFC session found...');
    }
  }

  void _consoleOutput(String message) {
    if (_logLevel == NFCLogLevel.debug) {
      developer.log(message);
    }
  }
}
