import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hive/hive.dart';

part 'overlay_profile.g.dart';

@HiveType(typeId: 5)
class OverlayProfile extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  List<DataWidgetProperties> widgetProperties = [];
}
