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

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) async* {
    if (event is SocketServerEventStart) {
      yield await startSocketServer();
    } else if (event is SocketServerEventStop) {
      await repo.stopSocketServer();
      yield SocketServerStateStopped();
    } else if (event is SocketServerEventMessage) {
      yield SocketServerStateRunning(message: event.message);
    }
  }

  Future<SocketServerState> startSocketServer() async {
    try {
      var server = await repo.startSocketServer();
      return SocketServerStateRunning(
          log: 'Serving at ws://${server.address.host}:${server.port}');
    } catch (error) {
      return SocketServerStateStopped(error: error);
    }
  }
}
