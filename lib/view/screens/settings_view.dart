import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/firebase/firebase_utils_stub.dart'
    if (dart.library.js) 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/widgets/drawers/navigation_drawer.dart';
import 'package:hds_overlay/view/widgets/settings_text_field.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController = Get.find();
  final FirebaseUtils firebase = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (context) {
          final darkModeToggle = Row(
            children: [
              Text('Dark mode'),
              Spacer(),
              Obx(
                () => Switch(
                  value: settingsController.settings.value.darkMode,
                  onChanged: (value) {
                    settingsController.settings.value.darkMode = value;
                    Get.changeThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light);
                    refreshAndSave();
                  },
                ),
              ),
            ],
          );

          final backgroundColorPicker = Row(
            children: [
              Text('Overlay background color'),
              Spacer(),
              Obx(() {
                final color = Color(
                  settingsController.settings.value.overlayBackgroundColor,
                );
                return Container(
                  width: 50,
                  height: 50,
                  decoration: color == Colors.transparent
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        )
                      : null,
                  child: colorCircle(
                    color,
                    () => showColorPickerDialog(
                      context,
                      settingsController.settings.value,
                    ),
                  ),
                );
              }),
            ],
          );

          final serverIpsEditor = Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Send data to these IPs'),
                      SizedBox(height: 3),
                      Text(
                        'Allow other HDS overlays to show your data',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      settingsController.settings.value.serverIps =
                          settingsController.settings.value.serverIps +
                              ['0.0.0.0'];
                      refreshAndSave();
                    },
                  ),
                ],
              ),
              // Wow this is really something
              // Correction this is horrifying
              Obx(
                () {
                  final widgets = List<int>.generate(
                    settingsController.settings.value.serverIps.length,
                    (i) => i,
                  )
                      .map((index) => [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 300,
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: settingsController
                                          .settings.value.serverIps[index],
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      final serverIps = settingsController
                                          .settings.value.serverIps;
                                      serverIps[index] = value;
                                      settingsController
                                          .settings.value.serverIps = serverIps;
                                      settingsController.settings.value.save();
                                    },
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    final serverIps = settingsController
                                        .settings.value.serverIps;
                                    serverIps.removeAt(index);
                                    settingsController
                                        .settings.value.serverIps = serverIps;
                                    refreshAndSave();
                                  },
                                  child: Text('DELETE'),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                          ])
                      .toList();

                  final List<Widget> widgetList;
                  if (widgets.isEmpty) {
                    widgetList = [];
                  } else {
                    widgetList =
                        widgets.reduce((value, element) => value + element);
                  }

                  return Column(
                    children: widgetList,
                  );
                },
              ),
            ],
          );

          final hdsCloudToggle = Row(
            children: [
              Text('HDS Cloud'),
              Spacer(),
              Obx(
                () => Switch(
                    value: settingsController.settings.value.hdsCloud,
                    onChanged: (value) {
                      settingsController.settings.value.hdsCloud = value;
                      if (value) {
                        firebase.signIn();
                      }
                      refreshAndSave();
                    }),
              ),
            ],
          );

          final settingsView = Obx(
            () => ListView(
              padding: EdgeInsets.all(20),
              children: [
                darkModeToggle,
                Visibility(
                  visible: kIsWeb,
                  child: Column(
                    children: [
                      Divider(),
                      hdsCloudToggle,
                      Divider(),
                      backgroundColorPicker,
                      Divider(),
                      SettingsTextField(
                        EditorType.dataClearInterval,
                        settingsController.settings.value,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      kIsWeb && !settingsController.settings.value.hdsCloud,
                  child: Column(
                    children: [
                      Divider(),
                      SettingsTextField(
                        EditorType.serverIp,
                        settingsController.settings.value,
                      ),
                      Divider(),
                      SettingsTextField(
                        EditorType.port,
                        settingsController.settings.value,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !kIsWeb,
                  child: Column(
                    children: [
                      Visibility(
                        visible: !settingsController.settings.value.hdsCloud,
                        child: Column(
                          children: [
                            Divider(),
                            SettingsTextField(
                              EditorType.clientName,
                              settingsController.settings.value,
                            ),
                            Divider(),
                            serverIpsEditor,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return settingsView;
              } else {
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.only(
                      left: 100, right: 100, top: 20, bottom: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: settingsView,
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget colorCircle(Color color, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget colorCircleWithSave(
      BuildContext context, Settings settings, Color color) {
    return colorCircle(color, () {
      settings.overlayBackgroundColor = color.value;
      refreshAndSave();
      Get.back();
    });
  }

  void showColorPickerDialog(BuildContext context, Settings settings) {
    final dialogOptions;
    if (kIsWeb) {
      dialogOptions = Row(
        children: [
          Spacer(),
          colorCircleWithSave(context, settings, Themes.dark.backgroundColor),
          Spacer(),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            child: Stack(
              children: [
                colorCircleWithSave(
                  context,
                  settings,
                  Colors.transparent,
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      );
    } else {
      dialogOptions = Row(
        children: [
          Spacer(),
          colorCircleWithSave(context, settings, AppColors.chromaGreen),
          Spacer(),
          colorCircleWithSave(context, settings, AppColors.chromaBlue),
          Spacer(),
          colorCircleWithSave(context, settings, AppColors.chromaMagenta),
          Spacer(),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a background color'),
          content: dialogOptions,
        );
      },
    );
  }

  void refreshAndSave() {
    settingsController.settings.refresh();
    settingsController.settings.value.save();
  }
}
