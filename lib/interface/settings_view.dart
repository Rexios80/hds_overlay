import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/blocs/hive/hive_bloc.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveBloc = BlocProvider.of<HiveBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawer(),
      body: ValueListenableBuilder(
        valueListenable: hiveBloc.hive.dataWidgetProperties.listenable(),
        builder: (context, Box box, widget) {
          return SettingsList(
            sections: [
              SettingsSection(
                title: 'Section',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {},
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
