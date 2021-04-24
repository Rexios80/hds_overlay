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
  final Map<DataType, DataMessage>? messages;
  final String? log;

  SocketServerStateRunning({this.messages, this.log});

  @override
  List<Object?> get props => [messages, log];
}
