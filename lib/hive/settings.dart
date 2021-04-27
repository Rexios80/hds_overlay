import 'package:hds_overlay/utils/colors.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  static final defaultPort = 3476;
  static final defaultOverlayBackgroundColor = AppColors.chromaGreen.value;
  static final defaultDarkMode = false;

  @HiveField(0)
  int port = defaultPort;

  @HiveField(1)
  int overlayBackgroundColor = defaultOverlayBackgroundColor;

  @HiveField(2)
  bool darkMode = defaultDarkMode;
}
