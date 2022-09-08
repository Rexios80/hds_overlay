import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/widgets/drawers/navigation_drawer.dart';
import 'package:hds_overlay/view/widgets/settings_text_field.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController = Get.find();
  final FirebaseUtils firebase = Get.find();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const NavigationDrawer(),
      body: Builder(
        builder: (context) {
          final darkModeToggle = Row(
            children: [
              const Text('Dark mode'),
              const Spacer(),
              Obx(
                () => Switch(
                  value: settingsController.settings.value.darkMode,
                  onChanged: (value) {
                    settingsController.settings.value.darkMode = value;
                    Get.changeThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                    refreshAndSave();
                  },
                ),
              ),
            ],
          );

          final backgroundColorPicker = Row(
            children: [
              const Text('Overlay background color'),
              const Spacer(),
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

          final hdsCloudToggle = Row(
            children: [
              const Text('HDS Cloud'),
              const Spacer(),
              Obx(
                () => Switch(
                  value: settingsController.settings.value.hdsCloud,
                  onChanged: (value) {
                    settingsController.settings.value.hdsCloud = value;
                    if (value) {
                      firebase.signIn();
                    }
                    refreshAndSave();
                  },
                ),
              ),
            ],
          );

          final settingsView = Obx(
            () => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                darkModeToggle,
                const Divider(),
                hdsCloudToggle,
                const Divider(),
                backgroundColorPicker,
                const Divider(),
                SettingsTextField(
                  EditorType.dataClearInterval,
                  settingsController.settings.value,
                ),
                Visibility(
                  visible: !settingsController.settings.value.hdsCloud,
                  child: Column(
                    children: [
                      const Divider(),
                      SettingsTextField(
                        EditorType.serverIp,
                        settingsController.settings.value,
                      ),
                      const Divider(),
                      SettingsTextField(
                        EditorType.port,
                        settingsController.settings.value,
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
                  margin: const EdgeInsets.only(
                    left: 100,
                    right: 100,
                    top: 20,
                    bottom: 20,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
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
    BuildContext context,
    Settings settings,
    Color color,
  ) {
    return colorCircle(color, () {
      settings.overlayBackgroundColor = color.value;
      refreshAndSave();
      Get.back();
    });
  }

  void showColorPickerDialog(BuildContext context, Settings settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a background color'),
          content: Row(
            children: [
              const Spacer(),
              colorCircleWithSave(
                context,
                settings,
                Themes.dark.backgroundColor,
              ),
              const Spacer(),
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
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  void refreshAndSave() {
    settingsController.settings.refresh();
    settingsController.settings.value.save();
  }
}
