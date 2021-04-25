import 'dart:async';

import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data_type.dart';

class HiveUtils {
  final _initStreamController = StreamController<void>.broadcast();

  Stream<void> get initStream {
    return _initStreamController.stream;
  }

  late Box<Settings> settings;
  late Box<DataWidgetProperties> dataWidgetProperties;

  void init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(Tuple2DoubleAdapter());
    Hive.registerAdapter(DataTypeAdapter());
    Hive.registerAdapter(DataWidgetPropertiesAdapter());
    Hive.registerAdapter(SettingsAdapter());

    settings = await Hive.openBox('settings');
    dataWidgetProperties = await Hive.openBox('dataWidgetProperties');

    // TODO: REMOVE
    await settings.clear();
    await dataWidgetProperties.clear();

    if (settings.values.isEmpty) {
      settings.add(Settings());
    }

    if (dataWidgetProperties.values.isEmpty) {
      dataWidgetProperties.add(
        DataWidgetProperties()
          ..dataType = DataType.heartRate
          ..position = Tuple2Double(10, 10),
      );

      dataWidgetProperties.add(
        DataWidgetProperties()
          ..dataType = DataType.calories
          ..position = Tuple2Double(100, 10),
      );
    }

    _initStreamController.add('');
  }

  void close() {
    _initStreamController.close();
  }
}
