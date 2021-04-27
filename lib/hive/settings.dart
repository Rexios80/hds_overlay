import 'package:get/get.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends Rxn with HiveObjectMixin {
  static final defaultPort = 3476;
  static final defaultOverlayBackgroundColor = AppColors.chromaGreen.value;
  static final defaultDarkMode = false;

  @HiveField(0)
  int _port = defaultPort;

  @HiveField(1)
  int _overlayBackgroundColor = defaultOverlayBackgroundColor;

  @HiveField(2)
  bool _darkMode = defaultDarkMode;

  int get port => _port;

  set port(int v) {
    _port = v;
    _saveAndRefresh();
  }

  int get overlayBackgroundColor => _overlayBackgroundColor;

  set overlayBackgroundColor(int v) {
    _overlayBackgroundColor = v;
    _saveAndRefresh();
  }

  bool get darkMode => _darkMode;

  set darkMode(bool v) {
    _darkMode = v;
    _saveAndRefresh();
  }

  void _saveAndRefresh() {
    try {
      save();
      refresh();
    } catch (error) {
      // This can get called before the object is actually in the box
    }
  }
}
