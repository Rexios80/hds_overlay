import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  int port = 3476;
}
