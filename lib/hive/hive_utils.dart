import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/controllers/overlay_profiles_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tuple/tuple.dart';

import 'data_type.dart';

class HiveUtils {
  static final boxSettings = 'settings';
  static final boxDataWidgetProperties = 'dataWidgetProperties';
  static final boxOverlayProfiles = 'overlayProfiles';

  static Future<void> init() async {
    await Hive.initFlutter('Health Data Server');

    Hive.registerAdapter(Tuple2DoubleAdapter());
    Hive.registerAdapter(DataTypeAdapter());
    Hive.registerAdapter(DataWidgetPropertiesAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(OverlayProfileAdapter());

    // Delete the boxes to prevent crashes while developing
    // if (kDebugMode) {
    //   print('Deleting hive boxes');
    //   await Hive.deleteBoxFromDisk(boxSettings);
    //   await Hive.deleteBoxFromDisk(boxDataWidgetProperties);
    // }

    final settingsBox = await Hive.openBox<Settings>(boxSettings);
    final dataWidgetPropertiesBox =
        await Hive.openBox<DataWidgetProperties>(boxDataWidgetProperties);
    final overlayProfilesBox =
        await Hive.openBox<OverlayProfile>(boxOverlayProfiles);

    if (settingsBox.values.isEmpty) {
      await settingsBox.add(Settings());
    }

    // Create default widget settings
    if (dataWidgetPropertiesBox.values.isEmpty) {
      await dataWidgetPropertiesBox.add(
        DataWidgetProperties()
          ..dataType = DataType.heartRate
          ..position = Tuple2Double(10, 10),
      );

      await dataWidgetPropertiesBox.add(
        DataWidgetProperties()
          ..dataType = DataType.calories
          ..position = Tuple2Double(200, 10),
      );
    }

    Get.put(SettingsController(settingsBox.getAt(0)!.obs));

    final dwc = Get.put(
        DataWidgetController(createDwpMap(dataWidgetPropertiesBox).obs));

    final opc =
        Get.put(OverlayProfilesController(overlayProfilesBox.values.toList().obs));

    // Refresh when properties are added or removed
    dataWidgetPropertiesBox.watch().listen((_) {
      dwc.propertiesMap.value = createDwpMap(dataWidgetPropertiesBox);
    });

    overlayProfilesBox.watch().listen((_) {
      opc.profiles.value = overlayProfilesBox.values.toList();
    });

    return Future.value();
  }

  static Map<Tuple2<DataType, String>, Rx<DataWidgetProperties>> createDwpMap(
      Box<DataWidgetProperties> dwpBox) {
    final map = Map<Tuple2<DataType, String>, Rx<DataWidgetProperties>>();
    dwpBox.values.forEach((e) => map[Tuple2(e.dataType, e.dataSource)] = e.obs);
    return map;
  }
}
