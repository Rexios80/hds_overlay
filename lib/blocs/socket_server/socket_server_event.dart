part of 'socket_server_bloc.dart';

@immutable
abstract class SocketServerEvent {}

class SocketServerEventStart extends SocketServerEvent {
  final int port;

  SocketServerEventStart(this.port);
}

class SocketServerEventStop extends SocketServerEvent {}

class SocketServerEventPortChange extends SocketServerEvent {
  final int port;

  SocketServerEventPortChange(this.port);
}

class SocketServerEventMessage extends SocketServerEvent {
  final DataMessageBase message;

  SocketServerEventMessage(this.message);
}

class SocketServerEventLog extends SocketServerEvent {
  final String log;

  SocketServerEventLog(this.log);
}
