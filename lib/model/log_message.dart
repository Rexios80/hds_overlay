import 'package:flutter/material.dart';
import 'package:hds_overlay/model/message.dart';

enum LogLevel {
  info,
  data,
  warn,
  error,
}

extension LogLevelExtension on LogLevel {
  Color get color {
    switch (this) {
      case LogLevel.info:
        return Colors.white;
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
  final LogLevel level;
  final String message;

  LogMessage(this.level, this.message);
}
