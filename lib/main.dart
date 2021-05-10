import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/routes.dart';
import 'package:hds_overlay/view/screens/overlay.dart';
import 'package:hds_overlay/view/screens/settings_view.dart';
import 'package:lifecycle/lifecycle.dart';

import 'controllers/settings_controller.dart';
import 'hive/hive_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hive = Get.put(HiveUtils());
  await hive.init();

  final SettingsController settingsController = Get.find();
  final FirebaseUtils firebase = Get.put(FirebaseUtils());

  // Only init Firebase if the user has it enabled
  if ((kIsWeb || Platform.isMacOS) &&
      settingsController.settings.value.hdsCloud) {
    // This will not work on other platforms
    // We must check kIsWeb first of Flutter web will complain
    await firebase.init();
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
