import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:lifecycle/lifecycle.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidget {
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(initialValue: 1.0);

    useAnimation(controller);

    return LifecycleWrapper(
      onLifecycleEvent: (LifecycleEvent event) async {
        while (true) {
          await controller.animateTo(0.8,
              duration: Duration(milliseconds: 1000));
          await controller.animateTo(1.0,
              duration: Duration(milliseconds: 500));
        }
      },
      child: Row(
        children: [
          Obx(() {
            final properties = dwc.propertiesMap[DataType.heartRate] ??
                DataWidgetProperties().obs;

            if (properties.value.showImage) {
              return SizedBox(
                height: properties.value.imageSize,
                width: properties.value.imageSize,
                child: Center(
                  child: SizedBox(
                    height: properties.value.imageSize * controller.value,
                    width: properties.value.imageSize * controller.value,
                    child: DataWidgetImage(square: true),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          DataWidgetText(),
        ],
      ),
    );
  }
}
