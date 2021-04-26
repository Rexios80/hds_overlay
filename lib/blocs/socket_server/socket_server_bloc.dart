import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/null_safety.dart';

part 'socket_server_event.dart';

part 'socket_server_state.dart';

class SocketServerBloc extends Bloc<SocketServerEvent, SocketServerState> {
  final HiveUtils _hive;
  final SocketServerRepo _repo;

  SocketServerBloc(this._hive, this._repo) : super(SocketServerStateStopped()) {
    final port = _hive.settings.port;

    // Calling add before the object is fully initialized won't update the state
    Future.delayed(
        Duration(milliseconds: 100), () => add(SocketServerEventStart(port)));

    _hive.settingsBox.watch().listen((event) {
      final port = _hive.settings.port;
      var portIsDifferent;
      try {
        portIsDifferent = port != _repo.server?.port;
      } catch (error) {
        // The server is not running
        portIsDifferent = true;
      }
      if (portIsDifferent) {
        add(SocketServerEventPortChange(port));
      }
    });
  }

  StreamSubscription? _messageStreamSubscription;
  StreamSubscription? _logStreamSubscription;

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) async* {
    if (state is SocketServerStateStopped && event is SocketServerEventStart) {
      yield await _startSocketServer(event.port);
      _setupStreamListeners();
    } else if (event is SocketServerEventMessage) {
      yield SocketServerStateRunning(
        messages: processMessage(event.message),
        log: appendMessageToLog(event.message),
      );
    } else if (event is SocketServerEventLog) {
      yield SocketServerStateRunning(log: appendToLog(event.log));
    } else if (event is SocketServerEventPortChange) {
      final log = cast<SocketServerStateRunning>(state)?.log ?? '';
      yield SocketServerStateStopped();
      yield await _restartSocketServer(event.port);
      yield SocketServerStateRunning(log: log);
    }
  }

  @override
  Future<void> close() async {
    await _stopSocketServer();
    super.close();
  }

  Future<SocketServerState> _startSocketServer(int port) async {
    try {
      await _repo.startSocketServer(port);
      return SocketServerStateRunning();
    } catch (error) {
      return SocketServerStateStopped(error: error);
    }
  }

  Future<void> _stopSocketServer() async {
    await _repo.stopSocketServer();
    _messageStreamSubscription?.cancel();
    _logStreamSubscription?.cancel();
  }

  Future<SocketServerState> _restartSocketServer(int port) async {
    await _repo.stopSocketServer();
    return await _startSocketServer(port);
  }

  void _setupStreamListeners() {
    _messageStreamSubscription = _repo.messageStream.listen((message) {
      add(SocketServerEventMessage(message));
    });
    _logStreamSubscription = _repo.logStream.listen((log) {
      print(log);
      add(SocketServerEventLog(log));
    });
  }

  String appendToLog(String log) {
    return '$log\n${cast<SocketServerStateRunning>(state)?.log ?? ''}';
  }

  String appendMessageToLog(DataMessageBase message) {
    return appendToLog('${message.name}: ${message.value}');
  }

  Map<DataType, DataMessage> processMessage(DataMessageBase message) {
    final map = cast<SocketServerStateRunning>(state)?.messages ?? Map();
    if (message is UnknownDataMessage) {
      // Don't do anything with these
      return map;
    }

    message as DataMessage;
    map[message.dataType] = message;
    return map;
  }
}
