import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/interface/data_view.dart';
import 'package:hds_overlay/interface/navigation_drawer.dart';
import 'package:hds_overlay/interface/settings_view.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/utils/null_safety.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:lifecycle/lifecycle.dart';

import 'blocs/socket_server/socket_server_bloc.dart';
import 'hive/hive_utils.dart';
import 'interface/log_view.dart';
import 'interface/routes.dart';

void main() async {
  final hive = HiveUtils();
  await hive.init();
  Get.put(hive);
  Get.put(SocketServerBloc(SocketServerRepo()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HiveUtils hive = Get.find();

  @override
  Widget build(BuildContext context) {
    DesktopWindow.setWindowSize(Size(1000, 500));
    DesktopWindow.setMaxWindowSize(Size(1000, 500));
    DesktopWindow.setMinWindowSize(Size(1000, 500));

    return GetMaterialApp(
      title: 'Health Data Server',
      navigatorObservers: [defaultLifecycleObserver],
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: hive.settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: Routes.overlay,
      getPages: [
        GetPage(name: Routes.overlay, page: () => HDSOverlay()),
        GetPage(name: Routes.settings, page: () => SettingsView()),
      ],
    );
  }
}

class HDSOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Data Server'),
      ),
      drawer: navigationDrawer,
      body: Center(
        child: BlocBuilder(
          bloc: Get.find<SocketServerBloc>(),
          builder: (context, SocketServerState state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child:
                      DataView(cast<SocketServerStateRunning>(state)?.messages),
                ),
                LogView(cast<SocketServerStateRunning>(state)?.log ?? ''),
              ],
            );
          },
        ),
      ),
    );
  }
}
