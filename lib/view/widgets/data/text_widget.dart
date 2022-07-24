import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/view/widgets/data/data_widget.dart';

class TextWidget extends DataWidgetBase {
  TextWidget({Key? key})
      : super.withWidgets(
          const SizedBox.shrink(),
          TextWidgetText(),
          key: key,
        );
}

class TextWidgetText extends DataWidgetText {
  TextWidgetText({super.key});

  @override
  String? getText(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) {
    return properties.value.text;
  }
}
