import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:provider/provider.dart';

import 'data_widget.dart';

class HeartRateWidget extends DataWidget {
  @override
  Widget build(BuildContext context) {
    final properties = Provider.of<DataWidgetProperties>(context);

    final controller = useAnimationController(
      duration: Duration(seconds: 3),
      initialValue: properties.imageSize,
      lowerBound: 0,
      upperBound: 500,
    );
    useAnimation(controller);

    controller.animateTo(properties.imageSize * (2 / 3)).then((_) {
      controller.animateTo(properties.imageSize);
    });

    return DataWidgetBase(
      child: Row(
        children: [
          DataWidgetImage(size: controller.value),
          DataWidgetText(),
        ],
      ),
    );
  }
}
