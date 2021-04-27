import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidget {
  @override
  Widget build(BuildContext context) {
    final properties = Provider.of<DataWidgetProperties>(context);

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
              height: properties.imageSize,
              width: properties.imageSize,
              child: Center(
                child: SizedBox(
                  height: properties.imageSize * controller.value,
                  width: properties.imageSize * controller.value,
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
