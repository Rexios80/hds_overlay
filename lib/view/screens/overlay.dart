import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/overlay_controller.dart';
import 'package:hds_overlay/controllers/overlay_profiles_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:lifecycle/lifecycle.dart';
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
  final FirebaseController firebaseController = Get.find();
  final SettingsController settingsController = Get.find();

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
              onPressed: () => overlayController.saveProfile(profileName),
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
          onSelected: overlayController.loadProfile,
          icon: Icon(Icons.upload_file),
          tooltip: 'Load profile',
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

    final actions = kIsWeb
        ? <Widget>[
            IconButton(
              icon: Icon(Icons.upload),
              tooltip: 'Export configuration',
              onPressed: () => exportConfig(),
            ),
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'Import configuration',
              onPressed: () => showImportDialog(),
            ),
            Builder(
              builder: (context) => PopupMenuButton(
                icon: Icon(Icons.save),
                tooltip: 'Create profile',
                itemBuilder: (BuildContext context) => profileAdd,
              ),
            ),
            profileLoad,
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add widget',
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ]
        : <Widget>[];

    return LifecycleWrapper(
      onLifecycleEvent: (LifecycleEvent event) {
        if (event == LifecycleEvent.push) {
          connectionController.start();
        } else if (event == LifecycleEvent.invisible) {
          connectionController.stop();
        }
      },
      child: Scaffold(
        backgroundColor: kIsWeb ? Colors.transparent : null,
        appBar: AppBar(
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Health Data Server'),
                    Obx(
                      () => Visibility(
                        visible: settingsController.settings.value.hdsCloud,
                        child: Text(
                          'HDS Cloud ID: ${firebaseController.config.value.overlayId}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Text('Health Data Server'),
                    Spacer(),
                    Visibility(
                      visible: settingsController.settings.value.hdsCloud,
                      child: Obx(() => Text(
                          'HDS Cloud ID: ${firebaseController.config.value.overlayId}')),
                    ),
                  ],
                );
              }
            },
          ),
          elevation: 0,
          actions: actions,
        ),
        drawerScrimColor: Colors.transparent,
        drawer: NavigationDrawer(),
        endDrawer: kIsWeb ? EndDrawer() : null,
        onEndDrawerChanged: (open) {
          if (!open) {
            // Reset the drawer when it is closed
            endDrawerController.selectedDataTypeSource.value =
                Tuple2(DataType.unknown, DataSource.watch);
          }
        },
        body: Container(
          color: kIsWeb ? Colors.transparent : Colors.black,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 750 && kIsWeb) {
                return Column(
                  children: [
                    DataView(),
                    Container(
                      height: constraints.maxHeight / 2,
                      child: LogView(),
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: kIsWeb,
                      child: DataView(),
                    ),
                    LogView(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void exportConfig() {
    Clipboard.setData(
      ClipboardData(
        text: jsonEncode(
          dwc.propertiesMap.values.map((e) => e.value).toList(),
        ),
      ),
    );

    Get.snackbar(
      'Configuration exported',
      'The current overlay configuration was copied to the clipboard.',
    );
  }

  void showImportDialog() {
    String import = '';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(50),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Paste an overlay configuration below',
                  style: Get.textTheme.headline6,
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Paste it here',
                  ),
                  onChanged: (value) => import = value,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => importConfig(import),
                  child: Text('Import'),
                ),
                SizedBox(height: 20),
                Text(
                  'This will overwrite the current overlay configuration',
                  style: Get.textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void importConfig(String import) {
    final properties = (jsonDecode(import) as List)
        .map((json) => DataWidgetProperties.fromJson(json))
        .toList();

    // Create a temporary profile to load
    final profile = OverlayProfile();
    profile.widgetProperties = properties;

    overlayController.loadProfile(profile);

    Get.back();
  }
}
