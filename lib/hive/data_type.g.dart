// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataTypeAdapter extends TypeAdapter<DataType> {
  @override
  final int typeId = 3;

  @override
  DataType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DataType.heartRate;
      case 1:
        return DataType.heartRateMin;
      case 2:
        return DataType.heartRateMax;
      case 3:
        return DataType.heartRateRanges;
      case 4:
        return DataType.heartRateAverage;
      case 5:
        return DataType.calories;
      case 6:
        return DataType.unknown;
      default:
        return DataType.heartRate;
    }
  }

  @override
  void write(BinaryWriter writer, DataType obj) {
    switch (obj) {
      case DataType.heartRate:
        writer.writeByte(0);
        break;
      case DataType.heartRateMin:
        writer.writeByte(1);
        break;
      case DataType.heartRateMax:
        writer.writeByte(2);
        break;
      case DataType.heartRateRanges:
        writer.writeByte(3);
        break;
      case DataType.heartRateAverage:
        writer.writeByte(4);
        break;
      case DataType.calories:
        writer.writeByte(5);
        break;
      case DataType.unknown:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
