import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/global_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/interface/data_view.dart';
import 'package:hds_overlay/interface/widget_selector.dart';
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
          ..position = Tuple2Double(100, 10),
      );
    }

    Get.put(SettingsController(settingsBox.getAt(0)!.obs));

    putDwpControllers(dataWidgetPropertiesBox.values);

    // Refresh when properties are added or removed
    dataWidgetPropertiesBox.watch().listen((event) {
      putDwpControllers(dataWidgetPropertiesBox.values);
      Get.find<GlobalController>().update([
        DataView.getBuilderId,
        WidgetSelector.getBuilderId,
      ]);
    });

    return Future.value();
  }

  static void putDwpControllers(Iterable<DataWidgetProperties> dwps) {
    Get.put(dwps);
    dwps.forEach((dwp) => Get.put<DataWidgetController>(
        DataWidgetController(dwp.obs),
        tag: dwp.dataType.toString()));
  }
}
