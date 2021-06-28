import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class WebAudioSource extends StreamAudioSource {
  Uint8List _buffer;

  WebAudioSource(this._buffer);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) {
    return Future.value(StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: _buffer.length,
      offset: 0,
      stream: Stream.value(_buffer.skip(start!).take(end! - start).toList()),
      contentType: 'audio/mpeg',
    ));
  }
}
