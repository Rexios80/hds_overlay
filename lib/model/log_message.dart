import 'package:flutter/material.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:intl/intl.dart';

enum LogLevel {
  info,
  good,
  hdsCloud,
  data,
  warn,
  error,
}

extension LogLevelExtension on LogLevel {
  Color get color {
    switch (this) {
      case LogLevel.info:
        return Colors.white;
      case LogLevel.good:
        return Colors.green;
      case LogLevel.hdsCloud:
        return Colors.orange;
      case LogLevel.data:
        return Colors.blue;
      case LogLevel.warn:
        return Colors.yellow;
      case LogLevel.error:
        return Colors.red;
    }
  }
}

class LogMessage extends MessageBase {
  final _dateFormat = DateFormat.Hms();

  final LogLevel level;
  final String message;

  LogMessage(this.level, this.message);

  String get timestampString => _dateFormat.format(timestamp);

  String get logLine => '($timestampString) $message';
}
