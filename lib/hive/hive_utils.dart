import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/overlay_profiles_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tuple/tuple.dart';

import 'data_type.dart';

class HiveUtils {
  final _boxSettings = 'settings';
  final _boxDataWidgetProperties = 'dataWidgetProperties';
  final _boxOverlayProfiles = 'overlayProfiles';

  late final Box<Settings> _settingsBox;
  late final Box<DataWidgetProperties> _dataWidgetPropertiesBox;
  late final Box<OverlayProfile> _overlayProfilesBox;

  late final ConnectionController _connectionController;
  late final DataWidgetController _dwc;

  Future<void> init() async {
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

    _settingsBox = await Hive.openBox<Settings>(_boxSettings);
    _dataWidgetPropertiesBox =
        await Hive.openBox<DataWidgetProperties>(_boxDataWidgetProperties);
    _overlayProfilesBox =
        await Hive.openBox<OverlayProfile>(_boxOverlayProfiles);

    if (_settingsBox.values.isEmpty) {
      await _settingsBox.add(Settings());
    }

    // Create default widget settings
    if (_dataWidgetPropertiesBox.values.isEmpty) {
      await _dataWidgetPropertiesBox.add(
        DataWidgetProperties()
          ..dataType = DataType.heartRate
          ..position = Tuple2Double(10, 10),
      );

      await _dataWidgetPropertiesBox.add(
        DataWidgetProperties()
          ..dataType = DataType.calories
          ..position = Tuple2Double(200, 10),
      );
    }

    Get.put(SettingsController(_settingsBox.getAt(0)!.obs));

    _connectionController = Get.put(ConnectionController());

    _dwc = Get.put(
        DataWidgetController(createDwpMap(_dataWidgetPropertiesBox).obs));

    final opc = Get.put(
        OverlayProfilesController(_overlayProfilesBox.values.toList().obs));

    // Refresh when properties are added or removed
    _dataWidgetPropertiesBox.watch().listen((_) {
      _dwc.propertiesMap.value = createDwpMap(_dataWidgetPropertiesBox);
    });

    _overlayProfilesBox.watch().listen((_) {
      opc.profiles.value = _overlayProfilesBox.values.toList();
    });

    return Future.value();
  }

  static Map<Tuple2<DataType, String>, Rx<DataWidgetProperties>> createDwpMap(
      Box<DataWidgetProperties> dwpBox) {
    final map = Map<Tuple2<DataType, String>, Rx<DataWidgetProperties>>();
    dwpBox.values.forEach((e) => map[Tuple2(e.dataType, e.dataSource)] = e.obs);
    return map;
  }

  void addWidget(DataType dataType, String dataSource) {
    _dataWidgetPropertiesBox.add(
      DataWidgetProperties()
        ..dataType = dataType
        ..dataSource = dataSource,
    );
  }

  void saveProfile(String profileName) {
    if (profileName.isEmpty) return;
    Get.back();

    // We have to copy the objects or they get edited unintentionally
    _overlayProfilesBox.add(
      OverlayProfile()
        ..name = profileName
        ..widgetProperties = _dwc.propertiesMap.values
            .map((e) => DataWidgetProperties.copy(e.value))
            .toList(),
    );

    _connectionController.logs
        .add(LogMessage(LogLevel.good, 'Profile saved: $profileName'));
  }

  void loadProfile(OverlayProfile profile) async {
    // Might be dangerous to delete everything but meh
    await _dataWidgetPropertiesBox.clear();
    // We have to copy the objects or they get edited unintentionally
    await _dataWidgetPropertiesBox.addAll(
        profile.widgetProperties.map((e) => DataWidgetProperties.copy(e)));

    _connectionController.logs
        .add(LogMessage(LogLevel.good, 'Profile loaded: ${profile.name}'));
  }
}
