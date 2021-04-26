import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:provider/provider.dart';

class DataWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final message = Provider.of<DataMessage>(context);

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

  const DataWidgetBase({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = Provider.of<DataWidgetProperties>(context);
    // TODO: Add default properties for new types

    return Positioned(
      left: properties.position.item1,
      top: properties.position.item2,
      child: child,
    );
  }
}

class DataWidgetImage extends StatelessWidget {
  final double? size;

  const DataWidgetImage({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final message = Provider.of<DataMessage>(context);
    final properties = Provider.of<DataWidgetProperties>(context);
    if (!properties.showImage) {
      return SizedBox.shrink();
    }
    final image = properties.image;
    final imageWidget = image == null
        ? Image.asset(
            getDefaultImage(message.dataType),
            height: size ?? properties.imageSize,
          )
        : Image.memory(
            image,
            height: size ?? properties.imageSize,
          );

    return imageWidget;
  }
}

class DataWidgetText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final message = Provider.of<DataMessage>(context);
    final properties = Provider.of<DataWidgetProperties>(context);

    return Padding(
      padding: EdgeInsets.only(
        left: properties.textPaddingLeft,
        top: properties.textPaddingTop,
      ),
      child: Text(
        message.value,
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
