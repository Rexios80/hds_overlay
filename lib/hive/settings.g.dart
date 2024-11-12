// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks

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
    return Settings(
      port:
          fields[0] == null ? Settings.defaultPort : (fields[0] as num).toInt(),
      overlayBackgroundColor: (fields[1] as num?)?.toInt(),
      darkMode:
          fields[2] == null ? Settings.defaultDarkMode : fields[2] as bool,
      overlayWidth: fields[3] == null ? 1280 : (fields[3] as num).toDouble(),
      overlayHeight: fields[4] == null ? 720 : (fields[4] as num).toDouble(),
      serverIp: fields[7] == null ? 'localhost' : fields[7] as String,
      hdsCloud: fields[8] == null ? true : fields[8] as bool,
      dataClearInterval: fields[9] == null ? 120 : (fields[9] as num).toInt(),
      rtdFallback: fields[10] == null ? false : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.port)
      ..writeByte(1)
      ..write(obj.overlayBackgroundColor)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj.overlayWidth)
      ..writeByte(4)
      ..write(obj.overlayHeight)
      ..writeByte(7)
      ..write(obj.serverIp)
      ..writeByte(8)
      ..write(obj.hdsCloud)
      ..writeByte(9)
      ..write(obj.dataClearInterval)
      ..writeByte(10)
      ..write(obj.rtdFallback);
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
