import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/blocs/hive/hive_bloc.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class DataWidget extends StatelessWidget {
  final DataType dataType;
  final dynamic value;

  const DataWidget(this.dataType, this.value, {Key? key}) : super(key: key);
}

class DataWidgetBase extends DataWidget {
  DataWidgetBase(DataType dataType, value, DataWidgetProperties properties)
      : super(dataType, value);

  @override
  Widget build(BuildContext context) {
    final hiveBloc = BlocProvider.of<HiveBloc>(context);

    return ValueListenableBuilder(
      valueListenable: hiveBloc.hive.dataWidgetProperties.listenable(),
      builder: (context, Box box, widget) {
        final properties =
            box.values.firstWhere((dwp) => dwp.dataType == dataType);

        return Positioned(
          left: properties.position.item1,
          top: properties.position.item2,
          child: Row(
            children: [
              createImage(properties),
              createValueText(properties),
            ],
          ),
        );
      },
    );
  }

  Widget createImage(DataWidgetProperties properties) {
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

  Widget createValueText(DataWidgetProperties properties) {
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
