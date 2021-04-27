import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidget {
  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    final DataWidgetController dwc = Get.find(tag: dataType.toString());

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
      child: DataWidgetBase(
        child: Row(
          children: [
            SizedBox(
              height: dwc.properties.value.imageSize,
              width: dwc.properties.value.imageSize,
              child: Center(
                child: SizedBox(
                  height: dwc.properties.value.imageSize * controller.value,
                  width: dwc.properties.value.imageSize * controller.value,
                  child: DataWidgetImage(square: true),
                ),
              ),
            ),
            DataWidgetText(),
          ],
        ),
      ),
    );
  }
}
