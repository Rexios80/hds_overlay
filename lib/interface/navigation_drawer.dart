import 'package:flutter/material.dart';
import 'package:hds_overlay/interface/routes.dart';
import 'package:hds_overlay/utils/colors.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Health Data Server',
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: AppColors.accent,
            ),
          ),
          ListTile(
            title: Text('Overlay'),
            onTap: () {
              if (currentRoute != Routes.overlay) {
                navigator.pushNamed(Routes.overlay);
              } else {
                navigator.pop();
              }
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              if (currentRoute != Routes.settings) {
                navigator.pushNamed(Routes.settings);
              } else {
                navigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
