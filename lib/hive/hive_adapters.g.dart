// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
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
    return DataWidgetProperties(
      dataType: fields[0] == null ? DataType.unknown : fields[0] as DataType,
      showImage: fields[1] == null ? true : fields[1] as bool,
      image: fields[2] as Uint8List?,
      imageSize: fields[3] == null ? 60 : (fields[3] as num).toDouble(),
      fontSize: fields[4] == null ? 36 : (fields[4] as num).toDouble(),
      textColor: (fields[5] as num?)?.toInt(),
      textPaddingLeft: fields[6] == null ? 14 : (fields[6] as num).toDouble(),
      font: fields[7] == null ? 'Monaco' : fields[7] as String,
      position: fields[8] == null
          ? const Tuple2Double(275, 150)
          : fields[8] as Tuple2Double,
      unit: fields[9] == null ? '' : fields[9] as String,
      style: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      textShadow: fields[11] == null ? false : fields[11] as bool,
      textShadowRadius: fields[12] == null ? 8 : (fields[12] as num).toDouble(),
      textStroke: fields[13] == null ? false : fields[13] as bool,
      textStrokeWidth: fields[14] == null ? 1 : (fields[14] as num).toDouble(),
      textPaddingTop: fields[15] == null ? 12 : (fields[15] as num).toDouble(),
      unitFontSize: fields[16] == null ? 24 : (fields[16] as num).toDouble(),
      decimals: fields[17] == null ? 1 : (fields[17] as num).toInt(),
      animated: fields[18] == null ? true : fields[18] as bool,
      heartRateRanges: (fields[19] as Map?)?.cast<int, int>(),
      heartBeatSound: fields[20] as Uint8List?,
      textInsideImage: fields[21] == null ? false : fields[21] as bool,
      dataSource: fields[22] == null ? DataSource.watch : fields[22] as String,
      scaleFactor: fields[23] == null ? 1 : (fields[23] as num).toDouble(),
      fontWeightString: fields[24] as String?,
      vertical: fields[25] == null ? false : fields[25] as bool,
      heartBeatSoundThreshold:
          fields[26] == null ? 0 : (fields[26] as num).toInt(),
      text: fields[27] == null ? 'Text' : fields[27] as String,
      colorImage: fields[28] == null ? false : fields[28] as bool,
      useGradient: fields[29] == null ? false : fields[29] as bool,
      gradientHighColorValue: (fields[30] as num?)?.toInt(),
      gradientLowColorValue: (fields[31] as num?)?.toInt(),
      imageColorValue: (fields[32] as num?)?.toInt(),
      gradientLowValue: fields[33] == null ? 40 : (fields[33] as num).toInt(),
      gradientHighValue: fields[34] == null ? 220 : (fields[34] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DataWidgetProperties obj) {
    writer
      ..writeByte(35)
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
      ..write(obj.textInsideImage)
      ..writeByte(22)
      ..write(obj.dataSource)
      ..writeByte(23)
      ..write(obj.scaleFactor)
      ..writeByte(24)
      ..write(obj.fontWeightString)
      ..writeByte(25)
      ..write(obj.vertical)
      ..writeByte(26)
      ..write(obj.heartBeatSoundThreshold)
      ..writeByte(27)
      ..write(obj.text)
      ..writeByte(28)
      ..write(obj.colorImage)
      ..writeByte(29)
      ..write(obj.useGradient)
      ..writeByte(30)
      ..write(obj.gradientHighColorValue)
      ..writeByte(31)
      ..write(obj.gradientLowColorValue)
      ..writeByte(32)
      ..write(obj.imageColorValue)
      ..writeByte(33)
      ..write(obj.gradientLowValue)
      ..writeByte(34)
      ..write(obj.gradientHighValue);
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
      case 4:
        return DataType.heartRateAverage;
      case 5:
        return DataType.calories;
      case 6:
        return DataType.stepCount;
      case 7:
        return DataType.distanceTraveled;
      case 8:
        return DataType.speed;
      case 9:
        return DataType.oxygenSaturation;
      case 10:
        return DataType.bodyMass;
      case 11:
        return DataType.bmi;
      case 12:
        return DataType.text;
      case 255:
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
      case DataType.heartRateMin:
        writer.writeByte(1);
      case DataType.heartRateMax:
        writer.writeByte(2);
      case DataType.heartRateAverage:
        writer.writeByte(4);
      case DataType.calories:
        writer.writeByte(5);
      case DataType.stepCount:
        writer.writeByte(6);
      case DataType.distanceTraveled:
        writer.writeByte(7);
      case DataType.speed:
        writer.writeByte(8);
      case DataType.oxygenSaturation:
        writer.writeByte(9);
      case DataType.bodyMass:
        writer.writeByte(10);
      case DataType.bmi:
        writer.writeByte(11);
      case DataType.text:
        writer.writeByte(12);
      case DataType.unknown:
        writer.writeByte(255);
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
      (fields[0] as num).toDouble(),
      (fields[1] as num).toDouble(),
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

class OverlayProfileAdapter extends TypeAdapter<OverlayProfile> {
  @override
  final int typeId = 5;

  @override
  OverlayProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OverlayProfile(
      name: fields[0] == null ? '' : fields[0] as String,
      dataWidgetProperties: (fields[1] as List?)?.cast<DataWidgetProperties>(),
      chartWidgetProperties:
          (fields[2] as List?)?.cast<ChartWidgetProperties>(),
    );
  }

  @override
  void write(BinaryWriter writer, OverlayProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dataWidgetProperties)
      ..writeByte(2)
      ..write(obj.chartWidgetProperties);
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

class FirebaseConfigAdapter extends TypeAdapter<FirebaseConfig> {
  @override
  final int typeId = 6;

  @override
  FirebaseConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseConfig(
      overlayId: fields[0] as String?,
    );
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

class ChartWidgetPropertiesAdapter extends TypeAdapter<ChartWidgetProperties> {
  @override
  final int typeId = 7;

  @override
  ChartWidgetProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartWidgetProperties(
      dataType: fields[0] == null ? DataType.unknown : fields[0] as DataType,
      dataSource: fields[1] == null ? DataSource.watch : fields[1] as String,
      position: fields[2] == null
          ? const Tuple2Double(275, 150)
          : fields[2] as Tuple2Double,
      rangeSeconds: fields[3] == null ? 300 : (fields[3] as num).toInt(),
      highColorValue: (fields[4] as num?)?.toInt(),
      lowColorValue: (fields[5] as num?)?.toInt(),
      width: fields[6] == null ? 100 : (fields[6] as num).toDouble(),
      height: fields[7] == null ? 50 : (fields[7] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, ChartWidgetProperties obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.dataSource)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.rangeSeconds)
      ..writeByte(4)
      ..write(obj.highColorValue)
      ..writeByte(5)
      ..write(obj.lowColorValue)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.height);
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
