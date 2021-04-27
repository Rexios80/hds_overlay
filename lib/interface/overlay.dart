import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';

import 'data_view.dart';
import 'end_drawer.dart';
import 'log_view.dart';
import 'navigation_drawer.dart';

class HDSOverlay extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Data Server'),
      ),
      drawerScrimColor: Colors.transparent,
      drawer: navigationDrawer,
      endDrawer: EndDrawer(),
      onEndDrawerChanged: (open) {
        if (!open) {
          // Reset the drawer when it is closed
          endDrawerController.selectedDataType.value = DataType.unknown;
        }
      },
      body: Container(
        color: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DataView(),
            LogView(),
          ],
        ),
      ),
    );
  }
}
