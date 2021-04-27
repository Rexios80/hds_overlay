import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
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
  final DataWidgetController dataWidgetController = Get.find();

  final Widget child;

  DataWidgetBase({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    // TODO: Add default properties for new types

    return Obx(
      () => Positioned(
        left:
            dataWidgetController.dataWidgetProperties[dataType]!.position.item1,
        top:
            dataWidgetController.dataWidgetProperties[dataType]!.position.item2,
        child: child,
      ),
    );
  }
}

class DataWidgetImage extends StatelessWidget {
  final DataWidgetController dataWidgetController = Get.find();

  final bool square;

  DataWidgetImage({Key? key, this.square = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);

    return Obx(() {
      if (!dataWidgetController.dataWidgetProperties[dataType]!.showImage) {
        return SizedBox.shrink();
      }
      final image = dataWidgetController.dataWidgetProperties[dataType]!.image;
      final imageWidget = image == null
          ? Image.asset(
              getDefaultImage(Provider.of<DataType>(context)),
              height: dataWidgetController
                  .dataWidgetProperties[dataType]!.imageSize,
              width: square
                  ? dataWidgetController
                      .dataWidgetProperties[dataType]!.imageSize
                  : null,
            )
          : Image.memory(
              image,
              height: dataWidgetController
                  .dataWidgetProperties[dataType]!.imageSize,
              width: square
                  ? dataWidgetController
                      .dataWidgetProperties[dataType]!.imageSize
                  : null,
            );

      return imageWidget;
    });
  }
}

class DataWidgetText extends StatelessWidget {
  final DataWidgetController dataWidgetController = Get.find();
  final SocketServerController socketServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);

    return Obx(
      () => Padding(
        padding: EdgeInsets.only(
          left: dataWidgetController
              .dataWidgetProperties[dataType]!.textPaddingLeft,
          top: dataWidgetController
              .dataWidgetProperties[dataType]!.textPaddingTop,
        ),
        child: Text(
          socketServerController.messages[dataType]?.value ?? '-',
          style: TextStyle(
            color: Color(
                dataWidgetController.dataWidgetProperties[dataType]!.textColor),
            fontSize:
                dataWidgetController.dataWidgetProperties[dataType]!.fontSize,
            fontFamily:
                dataWidgetController.dataWidgetProperties[dataType]!.font,
            foreground: () {
              if (dataWidgetController
                  .dataWidgetProperties[dataType]!.textStroke) {
                return Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = dataWidgetController
                      .dataWidgetProperties[dataType]!.textStrokeWidth
                  ..color = Colors.black;
              }
            }(),
            shadows: () {
              if (dataWidgetController
                  .dataWidgetProperties[dataType]!.textShadow) {
                return [
                  Shadow(
                    blurRadius: dataWidgetController
                        .dataWidgetProperties[dataType]!.textShadowRadius,
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
