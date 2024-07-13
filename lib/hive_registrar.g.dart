import 'package:hive_ce/hive.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/hive/firebase_config.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/settings.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(DataWidgetPropertiesAdapter());
    registerAdapter(Tuple2DoubleAdapter());
    registerAdapter(OverlayProfileAdapter());
    registerAdapter(FirebaseConfigAdapter());
    registerAdapter(ChartWidgetPropertiesAdapter());
    registerAdapter(DataTypeAdapter());
    registerAdapter(SettingsAdapter());
  }
}
