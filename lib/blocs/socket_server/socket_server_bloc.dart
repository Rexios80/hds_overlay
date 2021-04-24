import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';

part 'socket_server_event.dart';

part 'socket_server_state.dart';

class SocketServerBloc extends Bloc<SocketServerEvent, SocketServerState> {
  final SocketServerRepo _repo;

  SocketServerBloc(this._repo) : super(SocketServerStateStopped());

  StreamSubscription? _messageStreamSubscription;

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) async* {
    if (state is SocketServerStateStopped && event is SocketServerEventStart) {
      yield await _startSocketServer();
      _setupStreamListeners();
    } else if (state is SocketServerStateRunning &&
        event is SocketServerEventStop) {
      await _repo.stopSocketServer();
      _messageStreamSubscription?.cancel();
      yield SocketServerStateStopped();
    } else if (event is SocketServerEventMessage) {
      yield SocketServerStateRunning(message: event.message);
    } else if (event is SocketServerEventLog) {
      yield SocketServerStateRunning(log: event.log);
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
      print('it fucking works');
      add(SocketServerEventMessage(message));
    });
    _repo.logStream.listen((log) {
      print(log);
    });
  }
}
