import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/null_safety.dart';

part 'socket_server_event.dart';

part 'socket_server_state.dart';

class SocketServerBloc extends Bloc<SocketServerEvent, SocketServerState> {
  final SocketServerRepo _repo;

  SocketServerBloc(this._repo) : super(SocketServerStateStopped());

  StreamSubscription? _messageStreamSubscription;
  StreamSubscription? _logStreamSubscription;

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) async* {
    if (state is SocketServerStateStopped && event is SocketServerEventStart) {
      yield await _startSocketServer();
      _setupStreamListeners();
    } else if (state is SocketServerStateRunning &&
        event is SocketServerEventStop) {
      await _repo.stopSocketServer();
      _messageStreamSubscription?.cancel();
      _logStreamSubscription?.cancel();
      yield SocketServerStateStopped();
    } else if (event is SocketServerEventMessage) {
      yield SocketServerStateRunning(
        messages: processMessage(event.message),
        log: appendMessageToLog(event.message),
      );
    } else if (event is SocketServerEventLog) {
      yield SocketServerStateRunning(log: appendToLog(event.log));
    }
  }

  Future<SocketServerState> _startSocketServer() async {
    try {
      await _repo.startSocketServer();
      return SocketServerStateRunning();
    } catch (error) {
      return SocketServerStateStopped(error: error);
    }
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