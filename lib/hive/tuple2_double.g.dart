// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuple2_double.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Tuple2DoubleAdapter extends TypeAdapter<Tuple2Double> {
  @override
  final int typeId = 4;

  @override
  Tuple2Double read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tuple2Double(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Tuple2Double obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._item1)
      ..writeByte(1)
      ..write(obj._item2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple2DoubleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
