// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_widget_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataWidgetPropertiesAdapter extends TypeAdapter<DataWidgetProperties> {
  @override
  final int typeId = 0;

  @override
  DataWidgetProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataWidgetProperties()
      ..showImage = fields[0] as bool
      ..image = fields[1] as Uint8List?
      ..imageSize = fields[2] as double
      ..fontSize = fields[3] as double
      ..textColor = fields[4] as Color
      ..textPaddingLeft = fields[5] as double
      ..font = fields[6] as String
      ..position = fields[7] as Tuple2<double, double>
      ..unit = fields[8] as String
      ..style = fields[9] as int
      ..textShadow = fields[10] as bool
      ..textShadowRadius = fields[11] as double
      ..textStroke = fields[12] as bool
      ..textStrokeWidth = fields[13] as double
      ..textPaddingTop = fields[14] as double;
  }

  @override
  void write(BinaryWriter writer, DataWidgetProperties obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.showImage)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.imageSize)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.textColor)
      ..writeByte(5)
      ..write(obj.textPaddingLeft)
      ..writeByte(6)
      ..write(obj.font)
      ..writeByte(7)
      ..write(obj.position)
      ..writeByte(8)
      ..write(obj.unit)
      ..writeByte(9)
      ..write(obj.style)
      ..writeByte(10)
      ..write(obj.textShadow)
      ..writeByte(11)
      ..write(obj.textShadowRadius)
      ..writeByte(12)
      ..write(obj.textStroke)
      ..writeByte(13)
      ..write(obj.textStrokeWidth)
      ..writeByte(14)
      ..write(obj.textPaddingTop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataWidgetPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
