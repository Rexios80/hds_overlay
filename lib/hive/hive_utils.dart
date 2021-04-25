import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_type.dart';

class HiveUtils {
  static final boxSettings = 'settings';
  static final boxDataWidgetProperties = 'dataWidgetProperties';

  late Box<Settings> settings;
  late Box<DataWidgetProperties> dataWidgetProperties;

  Future<void> init() async {
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

    settings = await Hive.openBox(boxSettings);
    dataWidgetProperties = await Hive.openBox(boxDataWidgetProperties);

    if (settings.values.isEmpty) {
      await settings.add(Settings());
    }

    // Create default widget settings
    if (dataWidgetProperties.values.isEmpty) {
      await dataWidgetProperties.add(
        DataWidgetProperties()
          ..dataType = DataType.heartRate
          ..position = Tuple2Double(10, 10),
      );

      await dataWidgetProperties.add(
        DataWidgetProperties()
          ..dataType = DataType.calories
          ..position = Tuple2Double(200, 10),
      );
    }

    return Future.value();
  }
}
