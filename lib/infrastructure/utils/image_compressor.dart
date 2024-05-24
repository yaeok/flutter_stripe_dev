import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  Future<Uint8List> compress(Uint8List data, int maxByte) async {
    const baseQuality = 80;
    var lastCompressed = data;

    for (var i = 0; i < 5; i++) {
      var result = await FlutterImageCompress.compressWithList(
        data,
        minWidth: 2400,
        minHeight: 2400,
        quality: baseQuality - (i * 10),
      );

      if (result.length < maxByte) {
        log('COMPRESSED: ${result.length} bytes');
        return result;
      }

      log('NOT COMPRESSED: ${result.length} bytes');
      lastCompressed = result;
    }
    return lastCompressed;
  }
}
