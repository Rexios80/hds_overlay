import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:provider/provider.dart';

class DataWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DataWidgetImage(),
        DataWidgetText(),
      ],
    );
  }
}

class DataWidgetImage extends StatelessWidget {
  final bool square;

  DataWidgetImage({Key? key, this.square = false}) : super(key: key);

  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);

    return Obx(() {
      final properties =
          dwc.propertiesMap[dataType] ?? DataWidgetProperties().obs;
      if (!properties.value.showImage) {
        return SizedBox.shrink();
      }
      final image = properties.value.image;
      final imageSize = properties.value.imageSize;

      return Container(
        height: imageSize,
        width: square ? imageSize : null,
        child: Builder(builder: (context) {
          if (image == null) {
            return Image.asset(getDefaultImage(dataType));
          } else {
            return Image.memory(image);
          }
        }),
      );
    });
  }
}

class DataWidgetText extends StatelessWidget {
  final SocketServerController socketServerController = Get.find();
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);

    return Obx(
      () {
        final properties =
            dwc.propertiesMap[dataType] ?? DataWidgetProperties().obs;
        final value = socketServerController.messages[dataType]?.value;
        return Padding(
          padding: EdgeInsets.only(
            left: properties.value.textPaddingLeft,
            top: properties.value.textPaddingTop,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value ?? '-',
                style: TextStyle(
                  color: Color(properties.value.textColor),
                  fontSize: properties.value.fontSize,
                  fontFamily: properties.value.font,
                  foreground: () {
                    if (properties.value.textStroke) {
                      return Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = properties.value.textStrokeWidth
                        ..color = Colors.black;
                    }
                  }(),
                  shadows: () {
                    if (properties.value.textShadow) {
                      return [
                        Shadow(
                          blurRadius: properties.value.textShadowRadius,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ];
                    }
                  }(),
                ),
              ),
              SizedBox(width: 3),
              Text(
                value == null ? '' : properties.value.unit,
                style: TextStyle(
                  color: Color(properties.value.textColor),
                  fontSize: properties.value.unitFontSize,
                  fontFamily: properties.value.font,
                  foreground: () {
                    if (properties.value.textStroke) {
                      return Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = properties.value.textStrokeWidth
                        ..color = Colors.black;
                    }
                  }(),
                  shadows: () {
                    if (properties.value.textShadow) {
                      return [
                        Shadow(
                          blurRadius: properties.value.textShadowRadius,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ];
                    }
                  }(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
