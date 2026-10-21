import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:hive_ce/hive.dart';

part 'adapters.dart';

const appVersion = '13.2.0';

const colorWhite = 0xFFFFFFFF;
const colorBlack = 0xFF000000;
const colorTransparent = 0x00000000;
const colorRed = 0xFFF44336;
const colorGreen = 0xFF4CAF50;
const colorAccent = 0xFFE35C89;
const colorDarkBackground = 0xFF121212;

const dataSourceWatch = 'watch';
const dataSourceBrowser = 'browser';
const dataSourceHdsCloud = 'HDS Cloud';
const dataSourceUnknown = 'unknown';

const fontWeights = [
  'FontWeight.w100',
  'FontWeight.w200',
  'FontWeight.w300',
  'FontWeight.w400',
  'FontWeight.w500',
  'FontWeight.w600',
  'FontWeight.w700',
  'FontWeight.w800',
  'FontWeight.w900',
];

enum DataType {
  unknown,
  text,
  heartRate,
  heartRateMin,
  heartRateMax,
  heartRateAverage,
  calories,
  stepCount,
  distanceTraveled,
  speed,
  oxygenSaturation,
  bodyMass,
  bmi,
}

extension DataTypeInfo on DataType {
  bool get isRounded =>
      this == DataType.speed ||
      this == DataType.distanceTraveled ||
      this == DataType.bodyMass ||
      this == DataType.bmi ||
      this == DataType.oxygenSaturation;

  bool get isAnimated => this == DataType.heartRate;

  bool get usesPadding => this != DataType.text;

  String get defaultUnit => switch (this) {
    DataType.heartRate ||
    DataType.heartRateMin ||
    DataType.heartRateMax ||
    DataType.heartRateAverage => 'bpm',
    DataType.calories => 'kcal',
    DataType.distanceTraveled => 'm',
    DataType.speed => 'm/s',
    DataType.oxygenSaturation => '%',
    DataType.bodyMass => 'kg',
    DataType.bmi => 'kg/m²',
    _ => '',
  };

  String get defaultImage => switch (this) {
    DataType.heartRate ||
    DataType.heartRateMin ||
    DataType.heartRateMax ||
    DataType.heartRateAverage => 'images/hrImage.png',
    DataType.calories => 'images/calImage.gif',
    DataType.stepCount => 'images/stepImage.png',
    DataType.distanceTraveled => 'images/distanceImage.png',
    DataType.speed => 'images/speedImage.png',
    DataType.oxygenSaturation => 'images/wind.png',
    DataType.bodyMass || DataType.bmi => 'images/scale.png',
    _ => 'images/icon.png',
  };

  String get label {
    final unit = defaultUnit;
    final name = titleCase(this.name);
    return unit.isEmpty ? name : '$name ($unit)';
  }
}

DataType dataTypeFromName(String name) {
  for (final type in DataType.values) {
    if (type.name == name) return type;
  }
  return DataType.unknown;
}

String titleCase(String name) {
  final buffer = StringBuffer();
  for (var i = 0; i < name.length; i++) {
    final char = name[i];
    final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
    if (i > 0 && isUpper) buffer.write(' ');
    buffer.write(i == 0 ? char.toUpperCase() : char);
  }
  return buffer.toString();
}

String cssArgb(int value) {
  final a = (value >> 24) & 0xFF;
  final r = (value >> 16) & 0xFF;
  final g = (value >> 8) & 0xFF;
  final b = value & 0xFF;
  if (a == 0) return 'transparent';
  if (a == 255) {
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
  return 'rgba($r, $g, $b, ${(a / 255).toStringAsFixed(3)})';
}

int argbFromCssHex(String hex) {
  final cleaned = hex.replaceAll('#', '');
  if (cleaned.length == 6) return int.parse('FF$cleaned', radix: 16);
  if (cleaned.length == 8) return int.parse(cleaned, radix: 16);
  return colorWhite;
}

int cssFontWeight(String name) {
  final match = RegExp(r'(\d{3})').firstMatch(name);
  if (match != null) return int.parse(match.group(1)!);
  if (name.toLowerCase().contains('bold')) return 700;
  return 400;
}

int lerpHsv(int from, int to, double t) {
  final start = _hsvOf(from);
  final end = _hsvOf(to);
  final amount = t.clamp(0, 1).toDouble();
  return _argbOfHsv(
    start.$1 + (end.$1 - start.$1) * amount,
    start.$2 + (end.$2 - start.$2) * amount,
    start.$3 + (end.$3 - start.$3) * amount,
    start.$4 + (end.$4 - start.$4) * amount,
  );
}

(double, double, double, double) _hsvOf(int argb) {
  final a = ((argb >> 24) & 0xFF) / 255;
  final r = ((argb >> 16) & 0xFF) / 255;
  final g = ((argb >> 8) & 0xFF) / 255;
  final b = (argb & 0xFF) / 255;
  final maxChannel = max(r, max(g, b));
  final minChannel = min(r, min(g, b));
  final delta = maxChannel - minChannel;
  var hue = 0.0;
  if (delta != 0) {
    if (maxChannel == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (maxChannel == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }
  }
  if (hue < 0) hue += 360;
  final saturation = maxChannel == 0 ? 0.0 : delta / maxChannel;
  return (hue, saturation, maxChannel, a);
}

int _argbOfHsv(double h, double s, double v, double a) {
  final hue = ((h % 360) + 360) % 360;
  final saturation = s.clamp(0, 1).toDouble();
  final value = v.clamp(0, 1).toDouble();
  final alpha = a.clamp(0, 1).toDouble();
  final c = value * saturation;
  final x = c * (1 - ((hue / 60) % 2 - 1).abs());
  final m = value - c;
  final (double r1, double g1, double b1) = switch (hue) {
    < 60 => (c, x, 0.0),
    < 120 => (x, c, 0.0),
    < 180 => (0.0, c, x),
    < 240 => (0.0, x, c),
    < 300 => (x, 0.0, c),
    _ => (c, 0.0, x),
  };
  int channel(double color) => ((color + m) * 255).round().clamp(0, 255);
  return ((alpha * 255).round().clamp(0, 255) << 24) |
      (channel(r1) << 16) |
      (channel(g1) << 8) |
      channel(b1);
}

class Tuple2Double {
  const Tuple2Double(this.item1, this.item2);

  final double item1;
  final double item2;

  factory Tuple2Double.fromJson(Map json) => Tuple2Double(
    (json['item1'] as num?)?.toDouble() ?? 0,
    (json['item2'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {'item1': item1, 'item2': item2};
}

class Settings extends HiveObject {
  static const defaultPort = 3476;

  int port = defaultPort;
  int overlayBackgroundColor = colorTransparent;
  bool darkMode = false;
  double? _overlayWidth;
  double? _overlayHeight;
  String? _clientName;
  List<String>? _serverIps;
  String? _serverIp;
  bool? _hdsCloud;
  int? _dataClearInterval;
  bool? _rtdFallback;

  double get overlayWidth => _overlayWidth ?? 1280;
  set overlayWidth(double value) => _overlayWidth = value;

  double get overlayHeight => _overlayHeight ?? 720;
  set overlayHeight(double value) => _overlayHeight = value;

  set clientName(String value) => _clientName = value;

  String get serverIp => _serverIp ?? 'localhost';
  set serverIp(String value) => _serverIp = value;

  bool get hdsCloud => _hdsCloud ?? true;
  set hdsCloud(bool value) => _hdsCloud = value;

  int get dataClearInterval => _dataClearInterval ?? 120;
  set dataClearInterval(int value) => _dataClearInterval = value;
}

class FirebaseConfig extends HiveObject {
  late String overlayId;

  FirebaseConfig() {
    generateOverlayId();
  }

  void generateOverlayId() {
    overlayId = Random.secure().nextInt(pow(2, 32).toInt()).toString();
  }
}

class DataWidgetProperties extends HiveObject {
  DataWidgetProperties();

  DataType dataType = DataType.unknown;
  bool showImage = true;
  Uint8List? image;
  double imageSize = 60;
  double fontSize = 36;
  int textColor = colorWhite;
  double textPaddingLeft = 14;
  String font = 'Monaco';
  Tuple2Double position = const Tuple2Double(275, 150);
  String unit = '';
  int style = 0;
  bool textShadow = false;
  double textShadowRadius = 8;
  bool textStroke = false;
  double textStrokeWidth = 1;
  double textPaddingTop = 12;
  double unitFontSize = 24;
  int decimals = 1;
  bool animated = true;
  Map<int, int> heartRateRanges = {};
  Uint8List? heartBeatSound;
  bool? _textInsideImage;
  String? _dataSource;
  double? _scaleFactor;
  String? _fontWeight;
  bool? _vertical;
  int? _heartBeatSoundThreshold;
  String? _text;
  bool? _colorImage;
  bool? _useGradient;
  int? _gradientHighColor;
  int? _gradientLowColor;
  int? _imageColor;
  int? _gradientLowValue;
  int? _gradientHighValue;

  bool get textInsideImage => _textInsideImage ?? false;
  set textInsideImage(bool value) => _textInsideImage = value;

  String get dataSource => _dataSource ?? dataSourceWatch;
  set dataSource(String value) => _dataSource = value;

  double get scaleFactor => _scaleFactor ?? 1;
  set scaleFactor(double value) => _scaleFactor = value;

  String get fontWeight => _fontWeight ?? 'FontWeight.w400';
  set fontWeight(String value) => _fontWeight = value;

  bool get vertical => _vertical ?? false;
  set vertical(bool value) => _vertical = value;

  int get heartBeatSoundThreshold => _heartBeatSoundThreshold ?? 0;
  set heartBeatSoundThreshold(int value) => _heartBeatSoundThreshold = value;

  String get text => _text ?? 'Text';
  set text(String value) => _text = value;

  bool get colorImage => _colorImage ?? false;
  set colorImage(bool value) => _colorImage = value;

  bool get useGradient => _useGradient ?? false;
  set useGradient(bool value) => _useGradient = value;

  int get gradientHighColor => _gradientHighColor ?? colorRed;
  set gradientHighColor(int value) => _gradientHighColor = value;

  int get gradientLowColor => _gradientLowColor ?? colorGreen;
  set gradientLowColor(int value) => _gradientLowColor = value;

  int get imageColor => _imageColor ?? textColor;
  set imageColor(int value) => _imageColor = value;

  int get gradientLowValue => _gradientLowValue ?? 40;
  set gradientLowValue(int value) => _gradientLowValue = value;

  int get gradientHighValue => _gradientHighValue ?? 220;
  set gradientHighValue(int value) => _gradientHighValue = value;

  (DataType, String) get slot => (dataType, dataSource);

  DataWidgetProperties copy() =>
      DataWidgetProperties.fromJson(jsonDecode(jsonEncode(toJson())) as Map);

  factory DataWidgetProperties.fromJson(Map json) {
    final props = DataWidgetProperties();
    if (json['dataType'] is String)
      props.dataType = dataTypeFromName(json['dataType'] as String);
    if (json['showImage'] is bool) props.showImage = json['showImage'] as bool;
    props.image = _bytes(json['image']);
    if (json['imageSize'] is num)
      props.imageSize = (json['imageSize'] as num).toDouble();
    if (json['fontSize'] is num)
      props.fontSize = (json['fontSize'] as num).toDouble();
    if (json['textColor'] is num)
      props.textColor = (json['textColor'] as num).toInt();
    if (json['textPaddingLeft'] is num)
      props.textPaddingLeft = (json['textPaddingLeft'] as num).toDouble();
    if (json['font'] is String) props.font = json['font'] as String;
    if (json['position'] is Map)
      props.position = Tuple2Double.fromJson(json['position'] as Map);
    if (json['unit'] is String) props.unit = json['unit'] as String;
    if (json['style'] is num) props.style = (json['style'] as num).toInt();
    if (json['textShadow'] is bool)
      props.textShadow = json['textShadow'] as bool;
    if (json['textShadowRadius'] is num)
      props.textShadowRadius = (json['textShadowRadius'] as num).toDouble();
    if (json['textStroke'] is bool)
      props.textStroke = json['textStroke'] as bool;
    if (json['textStrokeWidth'] is num)
      props.textStrokeWidth = (json['textStrokeWidth'] as num).toDouble();
    if (json['textPaddingTop'] is num)
      props.textPaddingTop = (json['textPaddingTop'] as num).toDouble();
    if (json['unitFontSize'] is num)
      props.unitFontSize = (json['unitFontSize'] as num).toDouble();
    if (json['decimals'] is num)
      props.decimals = (json['decimals'] as num).toInt();
    if (json['animated'] is bool) props.animated = json['animated'] as bool;
    props.heartRateRanges = _intMap(json['heartRateRanges']);
    props.heartBeatSound = _bytes(json['heartBeatSound']);
    if (json['textInsideImage'] is bool)
      props.textInsideImage = json['textInsideImage'] as bool;
    if (json['dataSource'] is String)
      props.dataSource = json['dataSource'] as String;
    if (json['scaleFactor'] is num)
      props.scaleFactor = (json['scaleFactor'] as num).toDouble();
    if (json['fontWeight'] is String)
      props.fontWeight = json['fontWeight'] as String;
    if (json['vertical'] is bool) props.vertical = json['vertical'] as bool;
    if (json['heartBeatSoundThreshold'] is num) {
      props.heartBeatSoundThreshold = (json['heartBeatSoundThreshold'] as num)
          .toInt();
    }
    if (json['text'] is String) props.text = json['text'] as String;
    if (json['colorImage'] is bool)
      props.colorImage = json['colorImage'] as bool;
    if (json['useGradient'] is bool)
      props.useGradient = json['useGradient'] as bool;
    if (json['gradientHighColor'] is num)
      props.gradientHighColor = (json['gradientHighColor'] as num).toInt();
    if (json['gradientLowColor'] is num)
      props.gradientLowColor = (json['gradientLowColor'] as num).toInt();
    if (json['imageColor'] is num)
      props.imageColor = (json['imageColor'] as num).toInt();
    if (json['gradientLowValue'] is num)
      props.gradientLowValue = (json['gradientLowValue'] as num).toInt();
    if (json['gradientHighValue'] is num)
      props.gradientHighValue = (json['gradientHighValue'] as num).toInt();
    return props;
  }

  Map<String, dynamic> toJson() => {
    'dataType': dataType.name,
    'showImage': showImage,
    'image': image?.toList(),
    'imageSize': imageSize,
    'fontSize': fontSize,
    'textColor': textColor,
    'textPaddingLeft': textPaddingLeft,
    'font': font,
    'position': position,
    'unit': unit,
    'style': style,
    'textShadow': textShadow,
    'textShadowRadius': textShadowRadius,
    'textStroke': textStroke,
    'textStrokeWidth': textStrokeWidth,
    'textPaddingTop': textPaddingTop,
    'unitFontSize': unitFontSize,
    'decimals': decimals,
    'animated': animated,
    'heartRateRanges': heartRateRanges.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
    'heartBeatSound': heartBeatSound?.toList(),
    'textInsideImage': textInsideImage,
    'dataSource': dataSource,
    'scaleFactor': scaleFactor,
    'fontWeight': fontWeight,
    'vertical': vertical,
    'heartBeatSoundThreshold': heartBeatSoundThreshold,
    'text': text,
    'colorImage': colorImage,
    'useGradient': useGradient,
    'gradientHighColor': gradientHighColor,
    'gradientLowColor': gradientLowColor,
    'imageColor': imageColor,
    'gradientLowValue': gradientLowValue,
    'gradientHighValue': gradientHighValue,
  };
}

class ChartWidgetProperties extends HiveObject {
  ChartWidgetProperties();

  static const maxValuesToKeep = 500;

  DataType dataType = DataType.unknown;
  String dataSource = dataSourceWatch;
  Tuple2Double position = const Tuple2Double(275, 150);
  int rangeSeconds = 300;
  int? _highColor;
  int? _lowColor;
  double? _width;
  double? _height;

  int get highColor => _highColor ?? colorRed;
  set highColor(int value) => _highColor = value;

  int get lowColor => _lowColor ?? colorGreen;
  set lowColor(int value) => _lowColor = value;

  double get width => _width ?? 100;
  set width(double value) => _width = value;

  double get height => _height ?? 50;
  set height(double value) => _height = value;

  (DataType, String) get slot => (dataType, dataSource);

  ChartWidgetProperties copy() =>
      ChartWidgetProperties.fromJson(jsonDecode(jsonEncode(toJson())) as Map);

  factory ChartWidgetProperties.fromJson(Map json) {
    final props = ChartWidgetProperties();
    if (json['dataType'] is String)
      props.dataType = dataTypeFromName(json['dataType'] as String);
    if (json['dataSource'] is String)
      props.dataSource = json['dataSource'] as String;
    if (json['position'] is Map)
      props.position = Tuple2Double.fromJson(json['position'] as Map);
    if (json['rangeSeconds'] is num)
      props.rangeSeconds = (json['rangeSeconds'] as num).toInt();
    if (json['highColor'] is num)
      props.highColor = (json['highColor'] as num).toInt();
    if (json['lowColor'] is num)
      props.lowColor = (json['lowColor'] as num).toInt();
    if (json['width'] is num) props.width = (json['width'] as num).toDouble();
    if (json['height'] is num)
      props.height = (json['height'] as num).toDouble();
    return props;
  }

  Map<String, dynamic> toJson() => {
    'dataType': dataType.name,
    'dataSource': dataSource,
    'position': position,
    'rangeSeconds': rangeSeconds,
    'highColor': highColor,
    'lowColor': lowColor,
    'width': width,
    'height': height,
  };
}

class OverlayProfile extends HiveObject {
  OverlayProfile();

  String name = '';
  List<DataWidgetProperties> dataWidgetProperties = [];
  List<ChartWidgetProperties>? _chartWidgetProperties = [];

  List<ChartWidgetProperties> get chartWidgetProperties =>
      _chartWidgetProperties ?? [];
  set chartWidgetProperties(List<ChartWidgetProperties> value) =>
      _chartWidgetProperties = value;

  factory OverlayProfile.fromJson(Map json) {
    final profile = OverlayProfile()..name = json['name'] as String? ?? '';
    final widgets = json['dataWidgetProperties'];
    if (widgets is List) {
      profile.dataWidgetProperties = [
        for (final entry in widgets)
          if (entry is Map) DataWidgetProperties.fromJson(entry),
      ];
    }
    final charts = json['chartWidgetProperties'];
    if (charts is List) {
      profile.chartWidgetProperties = [
        for (final entry in charts)
          if (entry is Map) ChartWidgetProperties.fromJson(entry),
      ];
    }
    return profile;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'dataWidgetProperties': dataWidgetProperties,
    'chartWidgetProperties': chartWidgetProperties,
  };
}

class DataMessage {
  DataMessage(this.source, this.dataType, this.value, {DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  final String source;
  final DataType dataType;
  final String value;
  DateTime timestamp;

  String get name => titleCase(dataType.name);
}

class HrAverage {
  HrAverage(int heartRate) : _total = heartRate;

  int _total;
  int _count = 1;

  void add(int value) {
    _total += value;
    _count++;
  }

  double get average => _total / _count;
}

enum LogLevel { info, good, hdsCloud, data, warn, error }

class LogMessage {
  LogMessage(this.level, this.message) : timestamp = DateTime.now();

  final LogLevel level;
  final String message;
  final DateTime timestamp;

  String get line {
    String two(int value) => value.toString().padLeft(2, '0');
    return '(${two(timestamp.hour)}:${two(timestamp.minute)}:${two(timestamp.second)}) $message';
  }
}

Uint8List? _bytes(Object? value) {
  if (value is! List) return null;
  return Uint8List.fromList([
    for (final entry in value) (entry as num).toInt(),
  ]);
}

Map<int, int> _intMap(Object? value) {
  if (value is! Map) return {};
  final ranges = <int, int>{};
  value.forEach((key, entry) {
    final parsedKey = key is num ? key.toInt() : int.tryParse('$key');
    if (parsedKey != null && entry is num) ranges[parsedKey] = entry.toInt();
  });
  return ranges;
}

String newId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String hex(int value) => value.toRadixString(16).padLeft(2, '0');
  final text = bytes.map(hex).join();
  return '${text.substring(0, 8)}-${text.substring(8, 12)}-${text.substring(12, 16)}-${text.substring(16, 20)}-${text.substring(20)}';
}

int rangeColor(
  DataWidgetProperties properties,
  int heartRate, {
  required int fallback,
}) {
  if (properties.useGradient) {
    final span = properties.gradientHighValue - properties.gradientLowValue;
    if (span == 0) return fallback;
    final t = (heartRate - properties.gradientLowValue) / span;
    return lerpHsv(
      properties.gradientLowColor,
      properties.gradientHighColor,
      t,
    );
  }
  final ranges = properties.heartRateRanges.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  var color = fallback;
  for (final range in ranges) {
    if (heartRate >= range.key) color = range.value;
  }
  return color;
}
