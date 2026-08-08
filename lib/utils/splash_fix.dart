import 'dart:js_interop';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

@JS('hideSplash')
external void _hideSplash();

void hideSplash() {
  final logger = Get.find<Logger>();
  logger.d('hideSplash');
  _hideSplash();
}
