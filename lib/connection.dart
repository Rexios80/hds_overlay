import 'dart:async';
import 'dart:js_interop';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'firebase_client.dart';
import 'models.dart';
import 'store.dart';

abstract class LiveConnection {
  Future<void> start();
  Future<void> stop();
}

class RtdConnection implements LiveConnection {
  RtdConnection(this.store, this.client);

  final AppStore store;
  final FirebaseClient client;
  JSFunction? _messageCallback;
  JSFunction? _connectedCallback;
  DatabaseReference? _messageRef;
  DatabaseReference? _connectedRef;
  var _stopped = false;

  @override
  Future<void> start() async {
    _stopped = false;
    store.addLog(LogLevel.hdsCloud, 'Connecting to HDS Cloud...');
    await client.ensureSignedIn();
    if (_stopped) return;
    final overlayId = await _claim(store.overlayId);
    if (_stopped) return;
    _listen(overlayId);
  }

  FirebaseDatabase get _database => firebase.database();

  Future<String> _claim(String overlayId) async {
    final uidRef = _database.ref('overlays/$overlayId/uid');
    final raw = await uidRef.once('value').toDart;
    final snapshot = DataSnapshot(raw! as JSObject);
    final existing = snapshot.val()?.dartify()?.toString();
    if (snapshot.exists() && existing != client.uid) {
      store.addLog(LogLevel.error, 'HDS Cloud ID collision detected');
      store.addLog(LogLevel.error, 'Regenerating HDS Cloud ID...');
      return _claim(store.regenerateOverlayId());
    }
    if (!snapshot.exists()) {
      store.addLog(LogLevel.hdsCloud, 'Registering with HDS Cloud...');
      try {
        await uidRef.set(client.uid?.toJS).toDart;
        store.addLog(LogLevel.hdsCloud, 'Registered with HDS Cloud');
      } catch (_) {
        store.addLog(LogLevel.error, 'Unable to register with HDS Cloud');
      }
    }
    await _database
        .ref('overlays/$overlayId/lastConnected')
        .set(DateTime.now().toIso8601String().toJS)
        .toDart;
    return overlayId;
  }

  void _listen(String overlayId) {
    _messageRef = _database.ref('overlays/$overlayId/message');
    var first = true;
    _messageCallback = ((JSAny? raw) {
      if (first) {
        first = false;
        return;
      }
      if (raw == null || raw.isUndefinedOrNull) return;
      final value = DataSnapshot(raw as JSObject).val()?.dartify();
      if (value is! Map) return;
      final source = value['s']?.toString() ?? dataSourceUnknown;
      final type = value['t']?.toString() ?? '';
      final reading = value['v']?.toString() ?? '';
      store.ingest('$type:$reading', source);
    }).toJS;
    _messageRef!.on('value', _messageCallback!);

    _connectedRef = _database.ref('.info/connected');
    _connectedCallback = ((JSAny? raw) {
      if (raw == null || raw.isUndefinedOrNull) return;
      final connected = DataSnapshot(raw as JSObject).val()?.dartify() == true;
      store.addLog(
        LogLevel.hdsCloud,
        connected ? 'Connected to HDS Cloud' : 'Disconnected from HDS Cloud',
      );
    }).toJS;
    _connectedRef!.on('value', _connectedCallback!);
  }

  @override
  Future<void> stop() async {
    _stopped = true;
    if (_messageCallback != null) _messageRef?.off('value', _messageCallback);
    if (_connectedCallback != null)
      _connectedRef?.off('value', _connectedCallback);
    _messageCallback = null;
    _connectedCallback = null;
  }
}

class SocketConnection implements LiveConnection {
  SocketConnection(this.store);

  final AppStore store;
  var _stopped = true;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _retry;

  @override
  Future<void> start() async {
    _stopped = false;
    await _connect();
  }

  Future<void> _connect() async {
    if (_stopped) return;
    final uri = socketUri(store.settings.serverIp, store.settings.port);
    try {
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;
      await channel.ready;
      if (_stopped) {
        await channel.sink.close();
        return;
      }
      store.addLog(
        LogLevel.good,
        'Connected to server: ${store.settings.serverIp}',
      );
      _subscription = channel.stream.listen(
        (message) => store.ingest('$message', dataSourceWatch),
        onDone: _scheduleRetry,
        onError: (_) => _scheduleRetry(),
      );
    } catch (_) {
      store.addLog(
        LogLevel.error,
        'Unable to connect to server: ${store.settings.serverIp}',
      );
      _retry = Timer(const Duration(seconds: 10), () => unawaited(_connect()));
    }
  }

  void _scheduleRetry() {
    if (_stopped) return;
    store.addLog(
      LogLevel.warn,
      'Disconnected from server: ${store.settings.serverIp}',
    );
    unawaited(_subscription?.cancel());
    unawaited(_channel?.sink.close());
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 5), () => unawaited(_connect()));
  }

  @override
  Future<void> stop() async {
    _stopped = true;
    _retry?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
  }
}

Uri socketUri(String ip, int port) {
  final parsed = ip.startsWith('ws') ? Uri.parse(ip) : Uri.parse('ws://$ip');
  if (parsed.hasPort) return parsed;
  return parsed.replace(port: port);
}
