// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..port = fields[0] as int
      ..overlayBackgroundColor = fields[1] as int
      ..darkMode = fields[2] as bool
      .._overlayWidth = fields[3] as double?
      .._overlayHeight = fields[4] as double?
      .._clientName = fields[5] as String?
      .._serverIps = (fields[6] as List?)?.cast<String>()
      .._serverIp = fields[7] as String?
      .._hdsCloud = fields[8] as bool?
      .._dataClearInterval = fields[9] as int?
      .._rtdFallback = fields[10] as bool?;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.port)
      ..writeByte(1)
      ..write(obj.overlayBackgroundColor)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj._overlayWidth)
      ..writeByte(4)
      ..write(obj._overlayHeight)
      ..writeByte(5)
      ..write(obj._clientName)
      ..writeByte(6)
      ..write(obj._serverIps)
      ..writeByte(7)
      ..write(obj._serverIp)
      ..writeByte(8)
      ..write(obj._hdsCloud)
      ..writeByte(9)
      ..write(obj._dataClearInterval)
      ..writeByte(10)
      ..write(obj._rtdFallback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
