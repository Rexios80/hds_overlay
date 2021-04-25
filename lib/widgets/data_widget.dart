import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';

abstract class DataWidget extends StatelessWidget {
  final DataType dataType;
  final dynamic value;
  final DataWidgetProperties properties;

  const DataWidget(this.dataType, this.value, this.properties, {Key? key})
      : super(key: key);
}

class DataWidgetBase extends DataWidget {
  DataWidgetBase(DataType dataType, value, DataWidgetProperties properties)
      : super(dataType, value, properties);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: properties.position.item1,
      top: properties.position.item2,
      child: Row(
        children: [
          createImage(),
          createValueText(),
        ],
      ),
    );
  }

  Widget createImage() {
    if (!properties.showImage) {
      return SizedBox.shrink();
    }
    final image = properties.image;
    final imageWidget = image == null
        ? Image.asset(
            getDefaultImage(dataType),
            height: properties.imageSize,
          )
        : Image.memory(
            image,
            height: properties.imageSize,
          );

    return imageWidget;
  }

  Widget createValueText() {
    return Padding(
      padding: EdgeInsets.only(
        left: properties.textPaddingLeft,
        top: properties.textPaddingTop,
      ),
      child: Text(
        value,
        style: TextStyle(
          color: Color(properties.textColor),
          fontSize: properties.fontSize,
          fontFamily: properties.font,
          foreground: () {
            if (properties.textStroke) {
              return Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = properties.textStrokeWidth
                ..color = Colors.black;
            }
          }(),
          shadows: () {
            if (properties.textShadow) {
              return [
                Shadow(
                  blurRadius: properties.textShadowRadius,
                  color: Color.fromARGB(255, 0, 0, 0),
                )
              ];
            }
          }(),
        ),
      ),
    );
  }
}
