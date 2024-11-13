import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class Settings extends HiveObject {
  static const defaultPort = 3476;
  static final defaultOverlayBackgroundColor = Colors.transparent.value;
  static const defaultDarkMode = false;

  int port;
  int overlayBackgroundColor;
  bool darkMode;
  double overlayWidth;
  double overlayHeight;
  String serverIp;
  bool hdsCloud;
  int dataClearInterval;

  Settings({
    this.port = Settings.defaultPort,
    int? overlayBackgroundColor,
    this.darkMode = Settings.defaultDarkMode,
    this.overlayWidth = 1280,
    this.overlayHeight = 720,
    this.serverIp = 'localhost',
    this.hdsCloud = true,
    this.dataClearInterval = 120,
  }) : overlayBackgroundColor =
            overlayBackgroundColor ?? defaultOverlayBackgroundColor;
}
