// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:get/get.dart';
import 'package:logger/logger.dart';

void hideSplash() {
  final logger = Get.find<Logger>();
  logger.d('hideSplash');
  js.context.callMethod('hideSplash');
}
