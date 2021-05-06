import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:tuple/tuple.dart';

import '../screens/data_view.dart';
import 'drawers/end_drawer.dart';
import 'drawers/navigation_drawer.dart';
import 'log_view.dart';

class HDSOverlay extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kIsWeb ? Colors.transparent : null,
      appBar: AppBar(
        title: Text('Health Data Server'),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add),
              iconSize: 30,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      drawerScrimColor: Colors.transparent,
      drawer: navigationDrawer,
      endDrawer: EndDrawer(),
      onEndDrawerChanged: (open) {
        if (!open) {
          // Reset the drawer when it is closed
          endDrawerController.selectedDataTypeSource.value =
              Tuple2(DataType.unknown, DataSource.watch);
        }
      },
      body: Container(
        color: kIsWeb ? Colors.transparent : Colors.black,
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
