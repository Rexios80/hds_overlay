import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/overlay_controller.dart';
import 'package:hds_overlay/controllers/overlay_profiles_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:logger/logger.dart';

import 'package:hds_overlay/view/widgets/data_view.dart';
import 'package:hds_overlay/view/widgets/drawers/end_drawer.dart';
import 'package:hds_overlay/view/widgets/drawers/navigation_drawer.dart';
import 'package:hds_overlay/view/widgets/log_view.dart';

class HDSOverlay extends HookWidget {
  final _logger = Get.find<Logger>();
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final ChartWidgetController cwc = Get.find();
  final OverlayProfilesController overlayProfilesController = Get.find();
  final overlayController = Get.put(OverlayController());
  final ConnectionController connectionController = Get.find();
  final FirebaseController firebaseController = Get.find();
  final SettingsController settingsController = Get.find();

  HDSOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      // For some reason the full url isn't available instantly
      // Decode percent encoded url
      final split = Uri.decodeFull(Uri.base.toString()).split('?');
      if (split.length > 1) {
        // Why isn't null safe list access working?
        final parameters = {
          for (var e in split.last.split('&')) e.split('=')[0]: e.split('=')[1]
        };
        _logger.d('url parameters: $parameters');
        final urlConfig = parameters['config'];
        if (urlConfig != null) {
          _logger.d('Importing config from url');
          importConfig(urlConfig);
        }
      }
    });

    final peripherySlideAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 250),
      initialValue: 1.0,
    );

    final Animation<Offset> appBarOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -70),
      end: const Offset(0.0, 0.0),
    ).animate(peripherySlideAnimationController);

    final mounted = useIsMounted();
    ever(overlayController.mouseHovering, (bool mouseHovering) {
      // Only do this on web and if the widget is mounted
      if (!kIsWeb || !mounted()) return;

      if (mouseHovering) {
        peripherySlideAnimationController.forward();
      } else {
        peripherySlideAnimationController.reverse();
      }
    });

    var profileName = '';
    final profileAdd = [
      PopupMenuItem(
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                decoration: const InputDecoration(
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
          icon: const Icon(Icons.upload_file),
          tooltip: 'Load profile',
          itemBuilder: (BuildContext context) => overlayProfilesController
              .profiles
              .map(
                (profile) => PopupMenuItem<OverlayProfile>(
                  value: profile,
                  child: Row(
                    children: [
                      Text(profile.name),
                      const Spacer(),
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
                                const Duration(seconds: 1),
                                () => overlayController
                                    .profileDeleteButtonPressedMap
                                    .remove(profile),
                              );
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
              icon: const Icon(Icons.upload),
              tooltip: 'Export configuration',
              onPressed: () => showExportDialog(),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Import configuration',
              onPressed: () => showImportDialog(),
            ),
            Builder(
              builder: (context) => PopupMenuButton(
                icon: const Icon(Icons.save),
                tooltip: 'Create profile',
                itemBuilder: (BuildContext context) => profileAdd,
              ),
            ),
            profileLoad,
            // For some reason this has to be in a builder or it doesn't work
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add widget',
                onPressed: () => endDrawerController.widgetSelectionType.value =
                    DataWidgetType.data,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_chart),
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
              const Text('Health Data Server'),
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
              const Text('Health Data Server'),
              const Spacer(),
              Visibility(
                visible: settingsController.settings.value.hdsCloud,
                child: Obx(
                  () => Text(
                    'HDS Cloud ID: ${firebaseController.config.value.overlayId}',
                  ),
                ),
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
          backgroundColor: kIsWeb
              ? Color(settingsController.settings.value.overlayBackgroundColor)
              : null,
          drawerScrimColor: Colors.transparent,
          drawer: const NavigationDrawer(),
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
                        logOffsetAnimation = Tween<Offset>(
                          begin: Offset(0.0, constraints.maxHeight / 2),
                          end: const Offset(0.0, 0.0),
                        ).animate(peripherySlideAnimationController);
                      } else {
                        logOffsetAnimation = Tween<Offset>(
                          begin: const Offset(Themes.sideBarWidth, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(peripherySlideAnimationController);
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
                            SizedBox(
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

  void showExportDialog() {
    final tec = TextEditingController(
      text: jsonEncode(
        OverlayProfile()
          ..name = 'export'
          ..dataWidgetProperties =
              dwc.propertiesMap.values.map((e) => e.value).toList()
          ..chartWidgetProperties =
              cwc.propertiesMap.values.map((e) => e.value).toList(),
      ),
    );

    tec.selection = TextSelection(
      baseOffset: 0,
      extentOffset: tec.text.length,
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(50),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Copy the below config and put it somewhere safe',
                  style: Get.textTheme.headline6,
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: tec,
                  autofocus: true,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImportDialog() {
    String import = '';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(50),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Paste an overlay configuration below',
                  style: Get.textTheme.headline6,
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Paste it here',
                  ),
                  onChanged: (value) => import = value,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => importConfig(import),
                  child: const Text('Import'),
                ),
                const SizedBox(height: 20),
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
    // Create a temporary profile to load
    final profile = OverlayProfile.fromJson(jsonDecode(import));
    overlayController.loadProfile(profile);

    Get.back();
  }
}
