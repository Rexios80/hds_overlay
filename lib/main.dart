import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/interface/settings_view.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:lifecycle/lifecycle.dart';

import 'controllers/global_controller.dart';
import 'controllers/settings_controller.dart';
import 'hive/hive_utils.dart';
import 'interface/overlay.dart';
import 'interface/routes.dart';

void main() async {
  await HiveUtils.init();
  Get.put(GlobalController());
  Get.put(SocketServerController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.find();
  final titleBarHeight = 50.0; // TODO: Might need tweaking

  @override
  Widget build(BuildContext context) {
    final width = Themes.overlayWidth + Themes.sideBarWidth;
    final height = Themes.overlayHeight + kToolbarHeight + titleBarHeight;
    DesktopWindow.setWindowSize(Size(width, height));
    DesktopWindow.setMaxWindowSize(Size(width, height));
    DesktopWindow.setMinWindowSize(Size(width, height));

    return GetMaterialApp(
      title: 'Health Data Server',
      navigatorObservers: [defaultLifecycleObserver],
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: settingsController.settings.value.darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: Routes.overlay,
      getPages: [
        GetPage(name: Routes.overlay, page: () => HDSOverlay()),
        GetPage(name: Routes.settings, page: () => SettingsView()),
      ],
    );
  }
}
