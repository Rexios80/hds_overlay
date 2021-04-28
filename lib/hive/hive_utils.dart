import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_type.dart';

class HiveUtils {
  static final boxSettings = 'settings';
  static final boxDataWidgetProperties = 'dataWidgetProperties';

  static Future<void> init() async {
    await Hive.initFlutter('Health Data Server');

    Hive.registerAdapter(Tuple2DoubleAdapter());
    Hive.registerAdapter(DataTypeAdapter());
    Hive.registerAdapter(DataWidgetPropertiesAdapter());
    Hive.registerAdapter(SettingsAdapter());

    // Delete the boxes to prevent crashes while developing
    // if (kDebugMode) {
    //   print('Deleting hive boxes');
    //   await Hive.deleteBoxFromDisk(boxSettings);
    //   await Hive.deleteBoxFromDisk(boxDataWidgetProperties);
    // }

    final settingsBox = await Hive.openBox<Settings>(boxSettings);
    final dataWidgetPropertiesBox =
        await Hive.openBox<DataWidgetProperties>(boxDataWidgetProperties);

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
          ..position = Tuple2Double(100, 10),
      );
    }

    Get.put(SettingsController(settingsBox.getAt(0)!.obs));

    final dwc = Get.put(
        DataWidgetController(createDwpMap(dataWidgetPropertiesBox).obs));

    // Refresh when properties are added or removed
    dataWidgetPropertiesBox.watch().listen((_) {
      dwc.propertiesMap.value = createDwpMap(dataWidgetPropertiesBox);
    });

    return Future.value();
  }

  static Map<DataType, Rx<DataWidgetProperties>> createDwpMap(Box<DataWidgetProperties> dwpBox) {
    final map = Map<DataType, Rx<DataWidgetProperties>>();
    dwpBox.values.forEach((e) => map[e.dataType] = e.obs);
    return map;
  }
}
