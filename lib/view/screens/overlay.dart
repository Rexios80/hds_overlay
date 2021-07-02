import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:tuple/tuple.dart';

import '../widgets/data_view.dart';
import '../widgets/drawers/end_drawer.dart';
import '../widgets/drawers/navigation_drawer.dart';
import '../widgets/log_view.dart';

class HDSOverlay extends HookWidget {
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final OverlayProfilesController overlayProfilesController = Get.find();
  final overlayController = Get.put(OverlayController());
  final ConnectionController connectionController = Get.find();
  final FirebaseController firebaseController = Get.find();
  final SettingsController settingsController = Get.find();
  final HiveUtils _hive = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      // For some reason the full url isn't available instantly
      // Decode percent encoded url
      final split = Uri.decodeFull(Uri.base.toString()).split('?');
      if (split.length > 1) {
        // Why isn't null safe list access working?
        final parameters = Map.fromIterable(
          split.last.split('&'),
          key: (e) => e.split('=')[0],
          value: (e) => e.split('=')[1],
        );
        print('url parameters: $parameters');
        final urlConfig = parameters['config'];
        if (urlConfig != null) {
          print('Importing config from url');
          importConfig(urlConfig);
        }
      }
    });

    final appBarSlideController = useAnimationController(
      duration: const Duration(milliseconds: 250),
      initialValue: 1.0,
    );

    final logSlideController = useAnimationController(
      duration: const Duration(milliseconds: 250),
      initialValue: 1.0,
    );

    final Animation<Offset> appBarOffsetAnimation = new Tween<Offset>(
      begin: Offset(0.0, -70),
      end: Offset(0.0, 0.0),
    ).animate(appBarSlideController);

    final mounted = useIsMounted();
    ever(overlayController.mouseHovering, (bool mouseHovering) {
      // Only do this on web and if the widget is mounted
      if (!kIsWeb || !mounted()) return;

      if (mouseHovering) {
        appBarSlideController.forward();
        logSlideController.forward();
      } else {
        appBarSlideController.reverse();
        logSlideController.reverse();
      }
    });

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
            // For some reason this has to be in a builder or it doesn't work
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add widget',
                onPressed: () => endDrawerController.widgetSelectionType.value =
                    DataWidgetType.data,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_chart),
              tooltip: 'Add chart',
              onPressed: () => endDrawerController.widgetSelectionType.value =
                  DataWidgetType.chart,
            ),
          ]
        : <Widget>[];

    final appBarTitle = LayoutBuilder(
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
    );

    return LifecycleWrapper(
      onLifecycleEvent: (LifecycleEvent event) {
        if (event == LifecycleEvent.push) {
          connectionController.start();
        } else if (event == LifecycleEvent.invisible) {
          connectionController.stop();
        }
      },
      child: MouseRegion(
        onHover: (event) => overlayController.mouseHovering.value = true,
        child: Scaffold(
          backgroundColor: kIsWeb ? Colors.transparent : null,
          drawerScrimColor: Colors.transparent,
          drawer: NavigationDrawer(),
          endDrawer: kIsWeb ? EndDrawer() : null,
          onEndDrawerChanged: (open) {
            if (!open) {
              // Reset the drawer when it is closed
              endDrawerController.selectedDataWidgetDataTypeSource.value = null;
              endDrawerController.selectedChartDataTypeSource.value = null;
              endDrawerController.widgetSelectionType.value = null;
            }
          },
          body: Column(
            children: [
              AnimatedBuilder(
                animation: appBarOffsetAnimation,
                builder: (context, child) => Transform.translate(
                  offset: appBarOffsetAnimation.value,
                  child: AppBar(
                    title: appBarTitle,
                    elevation: 0,
                    actions: actions,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: kIsWeb ? Colors.transparent : Colors.black,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // This is kind of a weird place for this stuff to go but where else should it go
                      final Animation<Offset> logOffsetAnimation;
                      if (constraints.maxWidth < 750) {
                        logOffsetAnimation = new Tween<Offset>(
                          begin: Offset(0.0, constraints.maxHeight / 2),
                          end: Offset(0.0, 0.0),
                        ).animate(appBarSlideController);
                      } else {
                        logOffsetAnimation = new Tween<Offset>(
                          begin: Offset(Themes.sideBarWidth, 0.0),
                          end: Offset(0.0, 0.0),
                        ).animate(appBarSlideController);
                      }

                      Widget buildLogView() {
                        return AnimatedBuilder(
                          animation: logOffsetAnimation,
                          builder: (context, child) => Transform.translate(
                            offset: logOffsetAnimation.value,
                            child: LogView(),
                          ),
                        );
                      }

                      if (constraints.maxWidth < 750 && kIsWeb) {
                        return Column(
                          children: [
                            DataView(),
                            Container(
                              height: constraints.maxHeight / 2,
                              child: Obx(
                                () => Visibility(
                                  visible:
                                      overlayController.mouseHovering.value,
                                  child: buildLogView(),
                                ),
                              ),
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
                            Obx(
                              () => Visibility(
                                visible: overlayController.mouseHovering.value,
                                child: buildLogView(),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
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
      'The current overlay configuration was copied to the clipboard',
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
