import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/widgets/drawers/navigation_drawer.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: navigationDrawer,
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
                    refreshAndSave();
                    Get.changeTheme(value ? Themes.dark : Themes.light);
                  },
                ),
              ),
            ],
          );

          final portFieldTec = TextEditingController(
              text: settingsController.settings.value.port.toString());
          portFieldTec.selection =
              TextSelection.collapsed(offset: portFieldTec.text.length);
          final validatePort = (port) {
            return port >= 1234 && port <= 49151;
          };
          final portField = Row(
            children: [
              Text('WebSocket port'),
              Spacer(),
              Container(
                width: 100,
                child: Obx(
                  () => TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText:
                          !validatePort(settingsController.settings.value.port)
                              ? 'Invalid port'
                              : null,
                    ),
                    keyboardType: TextInputType.number,
                    controller: portFieldTec,
                    onChanged: (value) {
                      final port = int.tryParse(value) ?? 0;
                      if (validatePort(port)) {
                        settingsController.settings.value.port = port;
                        refreshAndSave();
                      }
                    },
                  ),
                ),
              ),
            ],
          );

          final backgroundColorPicker = Row(
            children: [
              Text('Overlay background color'),
              Spacer(),
              Obx(
                () => colorCircle(
                  Color(
                      settingsController.settings.value.overlayBackgroundColor),
                  () => showColorPickerDialog(
                      context, settingsController.settings.value),
                ),
              ),
            ],
          );

          final overlaySizeEditor = Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overlay size'),
                  SizedBox(height: 3),
                  Text('Minimum 800x600',
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
              Spacer(),
              Text('Width  '),
              Container(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: settingsController.settings.value.overlayWidth
                          .toStringAsFixed(0)),
                  onChanged: (value) {
                    final number = double.tryParse(value);
                    // Don't allow the user to make the window too small
                    if (number != null && number >= 800) {
                      settingsController.settings.value.overlayWidth = number;
                      refreshAndSave();
                    }
                  },
                ),
              ),
              SizedBox(width: 20),
              Text('Height  '),
              Container(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: settingsController.settings.value.overlayHeight
                          .toStringAsFixed(0)),
                  onChanged: (value) {
                    final number = double.tryParse(value);
                    // Don't allow the user to make the window too small
                    if (number != null && number >= 600) {
                      settingsController.settings.value.overlayHeight = number;
                      refreshAndSave();
                    }
                  },
                ),
              ),
            ],
          );

          final clientNameEditor = Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Client name'),
                  SizedBox(height: 3),
                  Text(
                    'Used to identify with other HDS overlays',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: 200,
                child: TextField(
                  controller: TextEditingController(
                    text: settingsController.settings.value.clientName,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      settingsController.settings.value.clientName = value,
                ),
              ),
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

          return Card(
            elevation: 8,
            margin: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                darkModeToggle,
                Divider(),
                portField,
                Divider(),
                backgroundColorPicker,
                Divider(),
                overlaySizeEditor,
                Divider(),
                clientNameEditor,
                Divider(),
                serverIpsEditor,
              ],
            ),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a background color to chroma key'),
          content: Row(
            children: [
              Spacer(),
              colorCircleWithSave(context, settings, AppColors.chromaGreen),
              Spacer(),
              colorCircleWithSave(context, settings, AppColors.chromaBlue),
              Spacer(),
              colorCircleWithSave(context, settings, AppColors.chromaMagenta),
              Spacer(),
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
