part of 'socket_server_bloc.dart';

@immutable
abstract class SocketServerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SocketServerEventStart extends SocketServerEvent {}

class SocketServerEventStop extends SocketServerEvent {}

class SocketServerEventMessage extends SocketServerEvent {
  final DataMessageBase message;

  SocketServerEventMessage(this.message);
}

class SocketServerEventLog extends SocketServerEvent {
  final String log;

  SocketServerEventLog(this.log);
}
