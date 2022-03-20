import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/utils/themes.dart';

class LogView extends StatelessWidget {
  final ConnectionController connectionController = Get.find();

  LogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Container(
        width: constraints.maxWidth < 750 ? null : Themes.sideBarWidth,
        decoration: const BoxDecoration(color: Colors.black),
        child: Obx(
          () {
            final logs = connectionController.logs;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                // Reverse the list of logs
                final log = logs[logs.length - index - 1];
                return Text(
                  log.logLine,
                  style: TextStyle(color: log.level.color),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
