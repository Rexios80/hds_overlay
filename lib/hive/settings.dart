import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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

  String get clientName =>
      kIsWeb ? DataSource.browser : _clientName ?? 'HDS-${const Uuid().v4()}';

  set clientName(String value) => _clientName = value;

  @HiveField(6)
  List<String>? _serverIps;

  List<String> get serverIps => _serverIps ?? [];
  set serverIps(List<String> value) => _serverIps = value;

  @HiveField(7)
  String? _serverIp = 'localhost';

  String get serverIp => _serverIp ?? 'localhost';
  set serverIp(String value) => _serverIp = value;

  @HiveField(8)
  bool? _hdsCloud;

  // Enable HDS Cloud for web by default (not supported on desktop)
  bool get hdsCloud => _hdsCloud ?? kIsWeb;
  set hdsCloud(bool value) => _hdsCloud = value;

  @HiveField(9)
  int? _dataClearInterval;

  int get dataClearInterval => _dataClearInterval ?? 120; // seconds
  set dataClearInterval(int value) => _dataClearInterval = value;
}
