import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  static final defaultPort = 3476;

  @HiveField(0)
  int port = defaultPort;
}
