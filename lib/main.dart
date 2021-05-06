import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/socket_client_controller.dart'
    if (dart.library.io) 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/routes.dart';
import 'package:hds_overlay/view/screens/settings_view.dart';
import 'package:hds_overlay/view/widgets/overlay.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';

import 'controllers/settings_controller.dart';
import 'hive/hive_utils.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;

  await HiveUtils.init();
  if (kIsWeb) {
    Get.put(SocketClientController());
  } else {
    Get.put(SocketServerController());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [defaultLifecycleObserver],
      title: 'Health Data Server',
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
