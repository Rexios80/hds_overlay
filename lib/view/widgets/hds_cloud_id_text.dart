import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';

class HdsCloudIdText extends StatelessWidget {
  final firebaseController = Get.find<FirebaseController>();
  final settingsController = Get.find<SettingsController>();

  final bool small;

  HdsCloudIdText({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: settingsController.settings.value.hdsCloud,
        child: Theme(
          data: Theme.of(context).copyWith(
              textSelectionTheme:
                  TextSelectionThemeData(selectionColor: Colors.black)),
          child: Builder(
            builder: (context) => SelectableText(
              'HDS Cloud ID: ${firebaseController.config.value.overlayId}',
              style: small
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
