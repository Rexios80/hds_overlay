// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OverlayProfileAdapter extends TypeAdapter<OverlayProfile> {
  @override
  final int typeId = 5;

  @override
  OverlayProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OverlayProfile()
      ..name = fields[0] as String
      ..widgetProperties = (fields[1] as List).cast<DataWidgetProperties>();
  }

  @override
  void write(BinaryWriter writer, OverlayProfile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.widgetProperties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverlayProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
