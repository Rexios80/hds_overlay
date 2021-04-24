part of 'socket_server_bloc.dart';

@immutable
abstract class SocketServerState extends Equatable {}

class SocketServerStateStopped extends SocketServerState {
  final Object? error;

  SocketServerStateStopped({this.error});

  @override
  List<Object?> get props => [error];
}

class SocketServerStateRunning extends SocketServerState {
  final DataMessageBase? message;
  final String? log;

  SocketServerStateRunning({this.message, this.log});

  @override
  List<Object?> get props => [message, log];
}
