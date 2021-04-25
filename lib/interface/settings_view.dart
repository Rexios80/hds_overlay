import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/blocs/hive/hive_bloc.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveBloc = BlocProvider.of<HiveBloc>(context);

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

          return SettingsList(
            sections: [
              SettingsSection(
                title: 'Style',
                tiles: [
                  SettingsTile.switchTile(
                    title: 'Dark mode',
                    leading: Icon(Icons.language),
                    switchValue: settings.darkMode,
                    onToggle: (bool value) {
                      settings.darkMode = value;
                      settings.save();
                    },
                  ),
                  SettingsTile.switchTile(
                    title: 'Use fingerprint',
                    leading: Icon(Icons.fingerprint),
                    switchValue: false,
                    onToggle: (bool value) {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
