import 'package:hds_overlay/controllers/connection_controller.dart';

class SocketClientController extends ConnectionController {
  @override
  void start() {
    // TODO: implement start
  }

  @override
  void stop() {
    // TODO: implement stop
  }
}

// This makes the compiler happy
class SocketServerController extends ConnectionController {
  @override
  void start() {}

  @override
  void stop() {}
}
