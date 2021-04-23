import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'socket_server_event.dart';

part 'socket_server_state.dart';

class SocketServerBloc extends Bloc<SocketServerEvent, SocketServerState> {
  SocketServerBloc(SocketServerState initialState) : super(initialState);

  @override
  Stream<SocketServerState> mapEventToState(SocketServerEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
