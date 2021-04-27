import 'dart:async';

import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      print('Deleting hive boxes');
      await Hive.deleteBoxFromDisk(boxSettings);
      await Hive.deleteBoxFromDisk(boxDataWidgetProperties);
    }

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
          ..position = Tuple2Double(200, 10),
      );
    }

    Get.put(SettingsController(settingsBox.getAt(0)!.obs));

    final dataWidgetController =
        Get.put(DataWidgetController(createDwpMap(dataWidgetPropertiesBox)));

    // Refresh when properties are added or removed
    dataWidgetPropertiesBox.watch().listen((event) {
      dataWidgetController.dataWidgetProperties.value =
          createDwpMap(dataWidgetPropertiesBox);
    });

    return Future.value();
  }

  static RxMap<DataType, DataWidgetProperties> createDwpMap(Box dwpBox) {
    return Map<DataType, DataWidgetProperties>.fromIterable(dwpBox.values,
        key: (e) => e.dataType, value: (e) => e).obs;
  }
}
