import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;

void saveTextFile(String text, String filename) {
  AnchorElement()
    ..href =
        '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: utf8)}'
    ..download = filename
    ..style.display = 'none'
    ..click();
}
