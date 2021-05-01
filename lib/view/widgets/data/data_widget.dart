import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:provider/provider.dart';

class DataWidgetBase extends HookWidget {
  final DataWidgetController dwc = Get.find();
  late final Widget image;
  late final Widget text;

  DataWidgetBase.withWidgets(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    final dataType = Provider.of<DataType>(context);
    final properties =
        dwc.propertiesMap[dataType] ?? DataWidgetProperties().obs;

    return Obx(() {
      if (properties.value.textInsideImage) {
        return Stack(
          alignment: Alignment.center,
          children: [
            properties.value.showImage ? image : SizedBox.shrink(),
            text,
          ],
        );
      } else {
        return Row(
          children: [
            properties.value.showImage ? image : SizedBox.shrink(),
            text
          ],
        );
      }
    });
  }
}

class DataWidget extends DataWidgetBase {
  DataWidget() : super.withWidgets(DataWidgetImage(), DataWidgetText());
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
        final preProcessedValue =
            socketServerController.messages[dataType]?.value;
        final String valueText;
        if (preProcessedValue == null) {
          valueText = '-';
        } else if (dataType.isRounded()) {
          valueText = double.parse(preProcessedValue)
              .toStringAsFixed(properties.value.decimals);
        } else {
          valueText = preProcessedValue;
        }

        final unitText = valueText == '-' ? '' : properties.value.unit;

        TextStyle fontStyle;
        try {
          fontStyle = GoogleFonts.getFont(properties.value.font);
        } catch (error) {
          // The font failed to load
          fontStyle = TextStyle(fontFamily: 'Monaco');
        }

        final textStyle = fontStyle.copyWith(
          fontSize: properties.value.fontSize,
        );
        final baseTextStyle = textStyle.copyWith(
          color: getTextColor(properties),
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
        );
        final strokeTextStyle = textStyle.copyWith(
          foreground: () {
            return Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = properties.value.textStrokeWidth
              ..color = Colors.black;
          }(),
        );
        final unitBaseTextStyle =
            baseTextStyle.copyWith(fontSize: properties.value.unitFontSize);
        final unitStrokeTextStyle =
            strokeTextStyle.copyWith(fontSize: properties.value.unitFontSize);

        return Padding(
          padding: EdgeInsets.only(
            left: properties.value.textPaddingLeft,
            right: properties.value.textPaddingLeft,
            top: properties.value.textPaddingTop,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Stack(
                children: [
                  Text(valueText, style: baseTextStyle),
                  properties.value.textStroke
                      ? Text(valueText, style: strokeTextStyle)
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(width: 3),
              Stack(
                children: [
                  Text(unitText, style: unitBaseTextStyle),
                  properties.value.textStroke
                      ? Text(unitText, style: unitStrokeTextStyle)
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color getTextColor(Rx<DataWidgetProperties> properties) {
    return Color(properties.value.textColor);
  }
}
