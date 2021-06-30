// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartPropertiesAdapter extends TypeAdapter<ChartProperties> {
  @override
  final int typeId = 7;

  @override
  ChartProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartProperties()
      ..dataType = fields[0] as DataType
      ..dataSource = fields[1] as String
      ..position = fields[2] as Tuple2Double;
  }

  @override
  void write(BinaryWriter writer, ChartProperties obj) {
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
      other is ChartPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
