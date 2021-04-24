import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/utils/colors.dart';
import 'package:hds_overlay/widgets/data_widget.dart';

class DataView extends StatelessWidget {
  final Map<DataType, DataMessage>? messages;

  const DataView(this.messages, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataWidgets = messages?.entries.map((e) => e.value).map((message) {
          return DataWidgetBase(
            message.dataType,
            message.value,
            {},
          );
        }).toList() ??
        [];

    return Container(
      color: AppColors.chromaGreen,
      child: Stack(
        children: dataWidgets,
      ),
    );
  }
}
