// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void hideSplash() {
  print('hideSplash');
  js.context.callMethod('hideSplash');
}
