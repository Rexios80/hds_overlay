import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/heart_rate_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidget {
  final DataWidgetController dwc = Get.find();
  final HeartRateWidgetController hrwc = Get.put(HeartRateWidgetController());

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(initialValue: 1.0);

    useAnimation(controller);

    return Row(
      children: [
        Obx(() {
          final properties = dwc.propertiesMap[DataType.heartRate] ??
              DataWidgetProperties().obs;

          ever(properties, (_) {
            if (properties.value.animated) {
              animateImage(controller);
            }
            hrwc.animating.value = properties.value.animated;
          });

          if (properties.value.animated && !hrwc.animating.value) {
            animateImage(controller);
          }

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
    );
  }

  void animateImage(AnimationController controller) async {
    hrwc.animating.value = true;
    while (hrwc.animating.value) {
      await controller.animateTo(0.8, duration: Duration(milliseconds: 1000));
      await controller.animateTo(1.0, duration: Duration(milliseconds: 500));
    }
  }
}
