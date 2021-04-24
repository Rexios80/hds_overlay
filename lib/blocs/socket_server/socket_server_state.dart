part of 'socket_server_bloc.dart';

@immutable
abstract class SocketServerState extends Equatable {
  @override
  List<Object> get props => [];
}

class SocketServerStateStopped extends SocketServerState {
  final Object? error;

  SocketServerStateStopped({this.error});
}

class SocketServerStateRunning extends SocketServerState {
  final DataMessageBase? message;
  final String? log;

  SocketServerStateRunning({this.message, this.log});
}
