import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:provider/provider.dart';

class DataWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return DataWidgetBase(
      child: Row(
        children: [
          DataWidgetImage(),
          DataWidgetText(),
        ],
      ),
    );
  }
}

class DataWidgetBase extends StatelessWidget {
  final Widget child;

  DataWidgetBase({Key? key, required this.child}) : super(key: key);

  final EndDrawerController endDrawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    final DataWidgetController dwc = Get.find(tag: dataType.toString());

    return Obx(
      () => Positioned(
        left: dwc.properties.value.position.item1,
        top: dwc.properties.value.position.item2,
        child: InkWell(
          onTap: () => endDrawerController.selectedDataType.value = dataType,
          child: child,
        ),
      ),
    );
  }
}

class DataWidgetImage extends StatelessWidget {
  final bool square;

  DataWidgetImage({Key? key, this.square = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    final DataWidgetController dwc = Get.find(tag: dataType.toString());

    return Obx(() {
      if (!dwc.properties.value.showImage) {
        return SizedBox.shrink();
      }
      final image = dwc.properties.value.image;
      final imageWidget = image == null
          ? Image.asset(
              getDefaultImage(Provider.of<DataType>(context)),
              height: dwc.properties.value.imageSize,
              width: square ? dwc.properties.value.imageSize : null,
            )
          : Image.memory(
              image,
              height: dwc.properties.value.imageSize,
              width: square ? dwc.properties.value.imageSize : null,
            );

      return imageWidget;
    });
  }
}

class DataWidgetText extends StatelessWidget {
  final SocketServerController socketServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    final DataWidgetController dwc = Get.find(tag: dataType.toString());

    return Obx(
      () => Padding(
        padding: EdgeInsets.only(
          left: dwc.properties.value.textPaddingLeft,
          top: dwc.properties.value.textPaddingTop,
        ),
        child: Text(
          socketServerController.messages[dataType]?.value ?? '-',
          style: TextStyle(
            color: Color(dwc.properties.value.textColor),
            fontSize: dwc.properties.value.fontSize,
            fontFamily: dwc.properties.value.font,
            foreground: () {
              if (dwc.properties.value.textStroke) {
                return Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = dwc.properties.value.textStrokeWidth
                  ..color = Colors.black;
              }
            }(),
            shadows: () {
              if (dwc.properties.value.textShadow) {
                return [
                  Shadow(
                    blurRadius: dwc.properties.value.textShadowRadius,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )
                ];
              }
            }(),
          ),
        ),
      ),
    );
  }
}
