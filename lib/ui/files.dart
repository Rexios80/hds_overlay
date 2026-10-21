import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<Uint8List> readFile(web.File file) {
  final reader = web.FileReader();
  final done = Completer<Uint8List>();
  reader.onload = ((web.Event _) {
    if (done.isCompleted) return;
    final result = reader.result;
    if (result == null) {
      done.completeError(StateError('Unable to read file'));
      return;
    }
    done.complete((result as JSArrayBuffer).toDart.asUint8List());
  }).toJS;
  reader.onerror = ((web.Event _) {
    if (!done.isCompleted)
      done.completeError(StateError('Unable to read file'));
  }).toJS;
  reader.readAsArrayBuffer(file);
  return done.future;
}
