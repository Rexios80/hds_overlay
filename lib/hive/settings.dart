import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  static const defaultPort = 3476;
  static final defaultOverlayBackgroundColor = Colors.transparent.value;
  static const defaultDarkMode = false;

  @HiveField(0)
  int port = defaultPort;

  @HiveField(1)
  int overlayBackgroundColor = defaultOverlayBackgroundColor;

  @HiveField(2)
  bool darkMode = defaultDarkMode;

  @HiveField(3)
  double? _overlayWidth;

  double get overlayWidth => _overlayWidth ?? 1280;
  set overlayWidth(double value) => _overlayWidth = value;

  @HiveField(4)
  double? _overlayHeight;

  double get overlayHeight => _overlayHeight ?? 720;
  set overlayHeight(double value) => _overlayHeight = value;

  @HiveField(5)
  String? _clientName;

  set clientName(String value) => _clientName = value;

  @HiveField(6)
  List<String>? _serverIps;

  @HiveField(7)
  String? _serverIp = 'localhost';

  String get serverIp => _serverIp ?? 'localhost';
  set serverIp(String value) => _serverIp = value;

  @HiveField(8)
  bool? _hdsCloud;

  bool get hdsCloud => _hdsCloud ?? true;
  set hdsCloud(bool value) => _hdsCloud = value;

  @HiveField(9)
  int? _dataClearInterval;

  int get dataClearInterval => _dataClearInterval ?? 120; // seconds
  set dataClearInterval(int value) => _dataClearInterval = value;
}
