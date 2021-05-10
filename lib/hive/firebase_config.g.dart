// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirebaseConfigAdapter extends TypeAdapter<FirebaseConfig> {
  @override
  final int typeId = 6;

  @override
  FirebaseConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseConfig()..overlayId = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, FirebaseConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.overlayId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
