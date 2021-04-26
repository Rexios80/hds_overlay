import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:hds_overlay/widgets/heart_rate_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class DataView extends StatelessWidget {
  final Map<DataType, DataMessage>? messages;

  const DataView(this.messages, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HiveUtils hive = Get.find();

    final dataWidgets = messages?.entries.map((e) => e.value).map((message) {
          return MultiProvider(
            providers: [
              Provider<DataMessage>(create: (context) => message),
              Provider<DataWidgetProperties>(
                  create: (context) => hive.dataWidgetPropertiesBox.values
                      .firstWhere((dwp) => dwp.dataType == message.dataType))
            ],
            child: ValueListenableBuilder(
              valueListenable: hive.dataWidgetPropertiesBox.listenable(),
              builder: (context, Box box, widget) {
                if (message.dataType == DataType.heartRate) {
                  return HeartRateWidget();
                }
                return DataWidget();
              },
            ),
          );
        }).toList() ??
        [];

    return Container(
      color: Color(hive.settings.overlayBackgroundColor),
      child: Stack(
        children: dataWidgets,
      ),
    );
  }
}
