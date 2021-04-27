import 'package:get/get.dart';
import 'package:hds_overlay/hive/settings.dart';

class SettingsController extends GetxService {
  final Rx<Settings> settings;

  SettingsController(this.settings);
}