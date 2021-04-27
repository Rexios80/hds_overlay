import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';

class EndDrawer extends StatelessWidget {
  final EndDrawerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    ever(controller.selectedDataType, (DataType dataType) {
      if (dataType != DataType.unknown) {
        scaffold.openEndDrawer();
      }
    });

    return Drawer(
      child: Obx(
        () {
          if (controller.selectedDataType.value == DataType.unknown) {
            return ListView(
              children: [
                Text('Widget selector'),
              ],
            );
          } else {
            return Text('Widget editor');
          }
        },
      ),
    );
  }
}
