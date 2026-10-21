part of 'models.dart';

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final fields = _readFields(reader);
    return Settings()
      ..port = (fields[0] as num?)?.toInt() ?? Settings.defaultPort
      ..overlayBackgroundColor =
          (fields[1] as num?)?.toInt() ?? colorTransparent
      ..darkMode = fields[2] as bool? ?? false
      .._overlayWidth = (fields[3] as num?)?.toDouble()
      .._overlayHeight = (fields[4] as num?)?.toDouble()
      .._clientName = fields[5] as String?
      .._serverIps = (fields[6] as List?)?.cast<String>()
      .._serverIp = fields[7] as String?
      .._hdsCloud = fields[8] as bool?
      .._dataClearInterval = (fields[9] as num?)?.toInt()
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
}

class DataTypeAdapter extends TypeAdapter<DataType> {
  @override
  final typeId = 3;

  @override
  DataType read(BinaryReader reader) {
    return switch (reader.readByte()) {
      0 => DataType.heartRate,
      1 => DataType.heartRateMin,
      2 => DataType.heartRateMax,
      4 => DataType.heartRateAverage,
      5 => DataType.calories,
      6 => DataType.stepCount,
      7 => DataType.distanceTraveled,
      8 => DataType.speed,
      9 => DataType.oxygenSaturation,
      10 => DataType.bodyMass,
      11 => DataType.bmi,
      12 => DataType.text,
      255 => DataType.unknown,
      _ => DataType.heartRate,
    };
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
}

class Tuple2DoubleAdapter extends TypeAdapter<Tuple2Double> {
  @override
  final typeId = 4;

  @override
  Tuple2Double read(BinaryReader reader) {
    final fields = _readFields(reader);
    return Tuple2Double(
      (fields[0] as num?)?.toDouble() ?? 0,
      (fields[1] as num?)?.toDouble() ?? 0,
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
}

class OverlayProfileAdapter extends TypeAdapter<OverlayProfile> {
  @override
  final typeId = 5;

  @override
  OverlayProfile read(BinaryReader reader) {
    final fields = _readFields(reader);
    return OverlayProfile()
      ..name = fields[0] as String? ?? ''
      ..dataWidgetProperties =
          (fields[1] as List?)?.cast<DataWidgetProperties>() ?? []
      .._chartWidgetProperties = (fields[2] as List?)
          ?.cast<ChartWidgetProperties>();
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
      ..write(obj._chartWidgetProperties);
  }
}

class FirebaseConfigAdapter extends TypeAdapter<FirebaseConfig> {
  @override
  final typeId = 6;

  @override
  FirebaseConfig read(BinaryReader reader) {
    final fields = _readFields(reader);
    return FirebaseConfig()
      ..overlayId = fields[0] as String? ?? FirebaseConfig().overlayId;
  }

  @override
  void write(BinaryWriter writer, FirebaseConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.overlayId);
  }
}

class ChartWidgetPropertiesAdapter extends TypeAdapter<ChartWidgetProperties> {
  @override
  final typeId = 7;

  @override
  ChartWidgetProperties read(BinaryReader reader) {
    final fields = _readFields(reader);
    return ChartWidgetProperties()
      ..dataType = fields[0] as DataType? ?? DataType.unknown
      ..dataSource = fields[1] as String? ?? dataSourceWatch
      ..position = fields[2] as Tuple2Double? ?? const Tuple2Double(275, 150)
      ..rangeSeconds = (fields[3] as num?)?.toInt() ?? 300
      .._highColor = (fields[4] as num?)?.toInt()
      .._lowColor = (fields[5] as num?)?.toInt()
      .._width = (fields[6] as num?)?.toDouble()
      .._height = (fields[7] as num?)?.toDouble();
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
      ..write(obj._highColor)
      ..writeByte(5)
      ..write(obj._lowColor)
      ..writeByte(6)
      ..write(obj._width)
      ..writeByte(7)
      ..write(obj._height);
  }
}

class DataWidgetPropertiesAdapter extends TypeAdapter<DataWidgetProperties> {
  @override
  final typeId = 0;

  @override
  DataWidgetProperties read(BinaryReader reader) {
    final fields = _readFields(reader);
    return DataWidgetProperties()
      ..dataType = fields[0] as DataType? ?? DataType.unknown
      ..showImage = fields[1] as bool? ?? true
      ..image = fields[2] as Uint8List?
      ..imageSize = (fields[3] as num?)?.toDouble() ?? 60
      ..fontSize = (fields[4] as num?)?.toDouble() ?? 36
      ..textColor = (fields[5] as num?)?.toInt() ?? colorWhite
      ..textPaddingLeft = (fields[6] as num?)?.toDouble() ?? 14
      ..font = fields[7] as String? ?? 'Monaco'
      ..position = fields[8] as Tuple2Double? ?? const Tuple2Double(275, 150)
      ..unit = fields[9] as String? ?? ''
      ..style = (fields[10] as num?)?.toInt() ?? 0
      ..textShadow = fields[11] as bool? ?? false
      ..textShadowRadius = (fields[12] as num?)?.toDouble() ?? 8
      ..textStroke = fields[13] as bool? ?? false
      ..textStrokeWidth = (fields[14] as num?)?.toDouble() ?? 1
      ..textPaddingTop = (fields[15] as num?)?.toDouble() ?? 12
      ..unitFontSize = (fields[16] as num?)?.toDouble() ?? 24
      ..decimals = (fields[17] as num?)?.toInt() ?? 1
      ..animated = fields[18] as bool? ?? true
      ..heartRateRanges = _hiveIntMap(fields[19])
      ..heartBeatSound = fields[20] as Uint8List?
      .._textInsideImage = fields[21] as bool?
      .._dataSource = fields[22] as String?
      .._scaleFactor = (fields[23] as num?)?.toDouble()
      .._fontWeight = fields[24] as String?
      .._vertical = fields[25] as bool?
      .._heartBeatSoundThreshold = (fields[26] as num?)?.toInt()
      .._text = fields[27] as String?
      .._colorImage = fields[28] as bool?
      .._useGradient = fields[29] as bool?
      .._gradientHighColor = (fields[30] as num?)?.toInt()
      .._gradientLowColor = (fields[31] as num?)?.toInt()
      .._imageColor = (fields[32] as num?)?.toInt()
      .._gradientLowValue = (fields[33] as num?)?.toInt()
      .._gradientHighValue = (fields[34] as num?)?.toInt();
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
      ..write(obj._textInsideImage)
      ..writeByte(22)
      ..write(obj._dataSource)
      ..writeByte(23)
      ..write(obj._scaleFactor)
      ..writeByte(24)
      ..write(obj._fontWeight)
      ..writeByte(25)
      ..write(obj._vertical)
      ..writeByte(26)
      ..write(obj._heartBeatSoundThreshold)
      ..writeByte(27)
      ..write(obj._text)
      ..writeByte(28)
      ..write(obj._colorImage)
      ..writeByte(29)
      ..write(obj._useGradient)
      ..writeByte(30)
      ..write(obj._gradientHighColor)
      ..writeByte(31)
      ..write(obj._gradientLowColor)
      ..writeByte(32)
      ..write(obj._imageColor)
      ..writeByte(33)
      ..write(obj._gradientLowValue)
      ..writeByte(34)
      ..write(obj._gradientHighValue);
  }
}

Map<int, dynamic> _readFields(BinaryReader reader) {
  final count = reader.readByte();
  return {for (var i = 0; i < count; i++) reader.readByte(): reader.read()};
}

Map<int, int> _hiveIntMap(Object? raw) {
  if (raw is! Map) return {};
  final ranges = <int, int>{};
  raw.forEach((key, value) {
    final parsedKey = key is num ? key.toInt() : int.tryParse('$key');
    if (parsedKey != null && value is num) ranges[parsedKey] = value.toInt();
  });
  return ranges;
}
