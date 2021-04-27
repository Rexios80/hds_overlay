import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/interface/widget_editor.dart';
import 'package:hds_overlay/interface/widget_selector.dart';

class EndDrawer extends StatelessWidget {
  final EndDrawerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () {
          if (controller.selectedDataType.value == DataType.unknown) {
            return WidgetSelector();
          } else {
            return WidgetEditor();
          }
        },
      ),
    );
  }
}
