import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  static const defaultPort = 3476;
  static final defaultOverlayBackgroundColor = Colors.transparent.value;
  static const defaultDarkMode = false;

  @HiveField(0)
  int port;

  @HiveField(1)
  int overlayBackgroundColor;

  @HiveField(2)
  bool darkMode;

  @HiveField(3)
  double overlayWidth;

  @HiveField(4)
  double overlayHeight;

  @HiveField(7)
  String serverIp;

  @HiveField(8)
  bool hdsCloud;

  @HiveField(9)
  int dataClearInterval;

  // TODO: Remove
  @HiveField(10)
  bool rtdFallback;

  Settings({
    this.port = Settings.defaultPort,
    int? overlayBackgroundColor,
    this.darkMode = Settings.defaultDarkMode,
    this.overlayWidth = 1280,
    this.overlayHeight = 720,
    this.serverIp = 'localhost',
    this.hdsCloud = true,
    this.dataClearInterval = 120,
    this.rtdFallback = false,
  }) : overlayBackgroundColor =
            overlayBackgroundColor ?? defaultOverlayBackgroundColor;
}
