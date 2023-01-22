// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

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
      ..write(obj.item1)
      ..writeByte(1)
      ..write(obj.item2);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tuple2Double _$Tuple2DoubleFromJson(Map<String, dynamic> json) => Tuple2Double(
      (json['item1'] as num).toDouble(),
      (json['item2'] as num).toDouble(),
    );

Map<String, dynamic> _$Tuple2DoubleToJson(Tuple2Double instance) =>
    <String, dynamic>{
      'item1': instance.item1,
      'item2': instance.item2,
    };
