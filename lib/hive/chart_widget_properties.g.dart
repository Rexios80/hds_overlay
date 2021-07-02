// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_widget_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartWidgetPropertiesAdapter extends TypeAdapter<ChartWidgetProperties> {
  @override
  final int typeId = 7;

  @override
  ChartWidgetProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartWidgetProperties()
      ..dataType = fields[0] as DataType
      ..dataSource = fields[1] as String
      ..position = fields[2] as Tuple2Double;
  }

  @override
  void write(BinaryWriter writer, ChartWidgetProperties obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.dataSource)
      ..writeByte(2)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartWidgetPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
