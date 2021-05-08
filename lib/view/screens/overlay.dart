import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/overlay_controller.dart';
import 'package:hds_overlay/controllers/overlay_profiles_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

import '../widgets/data_view.dart';
import '../widgets/drawers/end_drawer.dart';
import '../widgets/drawers/navigation_drawer.dart';
import '../widgets/log_view.dart';

class HDSOverlay extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final OverlayProfilesController overlayProfilesController = Get.find();
  final overlayController = Get.put(OverlayController());
  final ConnectionController connectionController = Get.find();

  @override
  Widget build(BuildContext context) {
    var profileName = '';
    final profileAdd = [
      PopupMenuItem(
        child: Row(
          children: [
            Container(
              width: 150,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Profile name',
                ),
                onChanged: (value) => profileName = value,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.save,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () => saveProfile(profileName),
            )
          ],
        ),
      ),
    ];

    // ffs this is ugly
    final profileLoad = Obx(
      () => Visibility(
        visible: overlayProfilesController.profiles.isNotEmpty,
        child: PopupMenuButton<OverlayProfile>(
          onSelected: loadProfile,
          icon: Icon(Icons.upload_file),
          itemBuilder: (BuildContext context) => overlayProfilesController
              .profiles
              .map(
                (profile) => PopupMenuItem<OverlayProfile>(
                  value: profile,
                  child: Row(
                    children: [
                      Text(profile.name),
                      Spacer(),
                      Obx(
                        () => IconButton(
                          icon: Icon(
                            overlayController.profileDeleteButtonPressedMap[
                                        profile] ??
                                    false
                                ? Icons.delete_forever
                                : Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (overlayController
                                    .profileDeleteButtonPressedMap[profile] ??
                                false) {
                              profile.delete();
                              Get.back();
                            } else {
                              overlayController
                                      .profileDeleteButtonPressedMap[profile] =
                                  true;
                              Future.delayed(
                                  Duration(seconds: 1),
                                  () => overlayController
                                      .profileDeleteButtonPressedMap
                                      .remove(profile));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );

    final actions = [
      Builder(
        builder: (context) => PopupMenuButton(
          icon: Icon(Icons.save),
          itemBuilder: (BuildContext context) => profileAdd,
        ),
      ),
      profileLoad,
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.add),
          iconSize: 30,
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: kIsWeb ? Colors.transparent : null,
      appBar: AppBar(
        title: Text('Health Data Server'),
        elevation: 0,
        actions: actions,
      ),
      drawerScrimColor: Colors.transparent,
      drawer: NavigationDrawer(),
      endDrawer: EndDrawer(),
      onEndDrawerChanged: (open) {
        if (!open) {
          // Reset the drawer when it is closed
          endDrawerController.selectedDataTypeSource.value =
              Tuple2(DataType.unknown, DataSource.watch);
        }
      },
      body: Container(
        color: kIsWeb ? Colors.transparent : Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DataView(),
            LogView(),
          ],
        ),
      ),
    );
  }

  void saveProfile(String profileName) {
    if (profileName.isEmpty) return;
    Get.back();

    // We have to copy the objects or they get edited unintentionally
    Hive.box<OverlayProfile>(HiveUtils.boxOverlayProfiles).add(
      OverlayProfile()
        ..name = profileName
        ..widgetProperties = dwc.propertiesMap.values
            .map((e) => DataWidgetProperties.copy(e.value))
            .toList(),
    );

    connectionController.logs
        .add(LogMessage(LogLevel.good, 'Profile saved: $profileName'));
  }

  void loadProfile(OverlayProfile profile) async {
    // Might be dangerous to delete everything but meh
    final box =
        Hive.box<DataWidgetProperties>(HiveUtils.boxDataWidgetProperties);

    await box.clear();
    // We have to copy the objects or they get edited unintentionally
    await box.addAll(
        profile.widgetProperties.map((e) => DataWidgetProperties.copy(e)));

    connectionController.logs
        .add(LogMessage(LogLevel.good, 'Profile loaded: ${profile.name}'));
  }
}
