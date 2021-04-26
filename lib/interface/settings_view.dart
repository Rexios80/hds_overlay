import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hive = Provider.of<HiveUtils>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: NavigationDrawer(),
      body: ValueListenableBuilder(
        valueListenable: hive.settingsBox.listenable(),
        builder: (context, Box box, widget) {
          final Settings settings = box.getAt(0);

          final darkModeToggle = Row(
            children: [
              Text('Dark mode'),
              Spacer(),
              Switch(
                value: settings.darkMode,
                onChanged: (value) {
                  settings.darkMode = value;
                  settings.save();
                },
              ),
            ],
          );

          final portFieldTec =
              TextEditingController(text: settings.port.toString());
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
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText:
                        !validatePort(settings.port) ? 'Invalid port' : null,
                  ),
                  keyboardType: TextInputType.number,
                  controller: portFieldTec,
                  onChanged: (value) {
                    final port = int.tryParse(value) ?? 0;
                    settings.port = port;
                    if (validatePort(port)) {
                      settings.save();
                    }
                  },
                ),
              ),
            ],
          );

          final backgroundColorPicker = Row(
            children: [
              Text('Overlay background color'),
              Spacer(),
              colorCircle(
                Color(settings.overlayBackgroundColor),
                () => showColorPickerDialog(context, settings),
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
                backgroundColorPicker
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
      settings.save();
      Navigator.of(context).pop();
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
}
