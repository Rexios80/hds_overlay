import 'dart:async';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:hds_overlay/model/data_message.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';

part 'socket_server_event.dart';

part 'socket_server_state.dart';

class SocketServerBloc extends Bloc<SocketServerEvent, SocketServerState> {
  final SocketServerRepo repo;

  SocketServerBloc(this.repo) : super(SocketServerStateStopped());

  StreamSubscription? messageStreamSubscription;

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) async* {
    if (state is SocketServerStateStopped && event is SocketServerEventStart) {
      yield await startSocketServer();
      setupStreamListeners();
    } else if (state is SocketServerStateRunning &&
        event is SocketServerEventStop) {
      await repo.stopSocketServer();
      messageStreamSubscription?.cancel();
      yield SocketServerStateStopped();
    } else if (event is SocketServerEventMessage) {
      yield SocketServerStateRunning(message: event.message);
    } else if (event is SocketServerEventLog) {
      yield SocketServerStateRunning(log: event.log);
    }
  }

  Future<SocketServerState> startSocketServer() async {
    try {
      await repo.startSocketServer();
      return SocketServerStateRunning();
    } catch (error) {
      return SocketServerStateStopped(error: error);
    }
  }

  void setupStreamListeners() {
    messageStreamSubscription = repo.messageStream.listen((message) {
      add(SocketServerEventMessage(message));
    });
  }
}
