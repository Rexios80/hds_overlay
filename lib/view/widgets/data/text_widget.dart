import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/view/widgets/data/data_widget.dart';

class TextWidget extends DataWidgetBase {
  TextWidget()
      : super.withWidgets(
          SizedBox.shrink(),
          TextWidgetText(),
        );
}

class TextWidgetText extends DataWidgetText {
  @override
  String? getText(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) {
    return properties.value.text;
  }
}
