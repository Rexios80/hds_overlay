import 'package:flutter/material.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:intl/intl.dart';

enum LogLevel {
  info(Colors.white),
  good(Colors.green),
  hdsCloud(Colors.orange),
  data(Colors.blue),
  warn(Colors.yellow),
  error(Colors.red);

  final Color color;

  const LogLevel(this.color);
}

class LogMessage extends MessageBase {
  final _dateFormat = DateFormat.Hms();

  final LogLevel level;
  final String message;

  LogMessage(this.level, this.message);

  String get timestampString => _dateFormat.format(timestamp);

  String get logLine => '($timestampString) $message';
}
