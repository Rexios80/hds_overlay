import 'package:flutter/material.dart';
import 'package:hds_overlay/blocs/hive/hive_bloc.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveBloc = Provider.of<HiveBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: NavigationDrawer(),
      body: ValueListenableBuilder(
        valueListenable: hiveBloc.hive.settings.listenable(),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
