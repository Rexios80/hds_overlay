import 'package:flutter/cupertino.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/model/default_image.dart';

enum DataWidgetProperty {
  image,
  textSize,
  textColor,
  font,
  position,
  unit,
  style,
}

abstract class DataWidget extends StatelessWidget {
  final DataType dataType;
  final dynamic value;
  final Map<DataWidgetProperty, dynamic> properties;

  const DataWidget(this.dataType, this.value, this.properties, {Key? key})
      : super(key: key);
}

class DataWidgetBase extends DataWidget {
  DataWidgetBase(
      DataType dataType, value, Map<DataWidgetProperty, dynamic> properties)
      : super(dataType, value, properties);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      () {
        final image = properties[DataWidgetProperty.image];
        return image == null
            ? Image.asset(getDefaultImage(dataType))
            : Image.memory(image);
      }(),
      Text(value),
    ]);
  }
}
