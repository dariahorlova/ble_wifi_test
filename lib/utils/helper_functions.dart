import 'dart:typed_data';

String bytesAsString(Uint8List bytes) => bytes
    .map((byte) => '0x${byte.toRadixString(16).padLeft(2, '0')}')
    .join(' ');
