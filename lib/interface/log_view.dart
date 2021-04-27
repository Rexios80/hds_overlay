import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/model/log_message.dart';

class LogView extends StatelessWidget {
  final SocketServerController socketServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(color: Colors.black),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Obx(
            () => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: socketServerController.logs.reversed.map((log) {
                  return Text(log.message,
                      style: TextStyle(color: log.level.color));
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
