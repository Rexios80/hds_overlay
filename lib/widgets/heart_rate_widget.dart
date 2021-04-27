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
  final DataWidgetController dataWidgetController = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
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
              height: dataWidgetController
                  .dataWidgetProperties[dataType]!.imageSize,
              width: dataWidgetController
                  .dataWidgetProperties[dataType]!.imageSize,
              child: Center(
                child: SizedBox(
                  height: dataWidgetController
                          .dataWidgetProperties[dataType]!.imageSize *
                      controller.value,
                  width: dataWidgetController
                          .dataWidgetProperties[dataType]!.imageSize *
                      controller.value,
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
