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
      ..dataType = fields[0] as DataType
      ..showImage = fields[1] as bool
      ..image = fields[2] as Uint8List?
      ..imageSize = fields[3] as double
      ..fontSize = fields[4] as double
      ..textColor = fields[5] as int
      ..textPaddingLeft = fields[6] as double
      ..font = fields[7] as String
      ..position = fields[8] as Tuple2Double
      ..unit = fields[9] as String
      ..style = fields[10] as int
      ..textShadow = fields[11] as bool
      ..textShadowRadius = fields[12] as double
      ..textStroke = fields[13] as bool
      ..textStrokeWidth = fields[14] as double
      ..textPaddingTop = fields[15] as double
      ..unitFontSize = fields[16] as double
      ..decimals = fields[17] as int
      ..animated = fields[18] as bool
      ..heartRateRanges = (fields[19] as Map).cast<int, int>()
      ..heartBeatSound = fields[20] as Uint8List?
      .._textInsideImage = fields[21] as bool?
      .._dataSource = fields[22] as String?
      .._scaleFactor = fields[23] as double?
      .._fontWeight = fields[24] as String?
      .._vertical = fields[25] as bool?
      .._heartBeatSoundThreshold = fields[26] as int?
      .._text = fields[27] as String?;
  }

  @override
  void write(BinaryWriter writer, DataWidgetProperties obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.showImage)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.imageSize)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.textColor)
      ..writeByte(6)
      ..write(obj.textPaddingLeft)
      ..writeByte(7)
      ..write(obj.font)
      ..writeByte(8)
      ..write(obj.position)
      ..writeByte(9)
      ..write(obj.unit)
      ..writeByte(10)
      ..write(obj.style)
      ..writeByte(11)
      ..write(obj.textShadow)
      ..writeByte(12)
      ..write(obj.textShadowRadius)
      ..writeByte(13)
      ..write(obj.textStroke)
      ..writeByte(14)
      ..write(obj.textStrokeWidth)
      ..writeByte(15)
      ..write(obj.textPaddingTop)
      ..writeByte(16)
      ..write(obj.unitFontSize)
      ..writeByte(17)
      ..write(obj.decimals)
      ..writeByte(18)
      ..write(obj.animated)
      ..writeByte(19)
      ..write(obj.heartRateRanges)
      ..writeByte(20)
      ..write(obj.heartBeatSound)
      ..writeByte(21)
      ..write(obj._textInsideImage)
      ..writeByte(22)
      ..write(obj._dataSource)
      ..writeByte(23)
      ..write(obj._scaleFactor)
      ..writeByte(24)
      ..write(obj._fontWeight)
      ..writeByte(25)
      ..write(obj._vertical)
      ..writeByte(26)
      ..write(obj._heartBeatSoundThreshold)
      ..writeByte(27)
      ..write(obj._text);
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
