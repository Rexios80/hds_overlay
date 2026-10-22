import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

const firebaseApiKey = 'AIzaSyCbbBPvlWvmOvI6Is8PYXNpJ78N03AYcyU';
const firebaseAppId = '1:47929674141:web:0606fd3354256f51860774';
const firebaseMessagingSenderId = '47929674141';
const firebaseProjectId = 'health-data-server';
const firebaseAuthDomain = 'health-data-server.firebaseapp.com';
const firebaseDatabaseUrl =
    'https://health-data-server-default-rtdb.firebaseio.com';
const firebaseStorageBucket = 'health-data-server.appspot.com';
const firebaseMeasurementId = 'G-1V10QYSSHG';

@JS('firebase')
external FirebaseJs? get _firebase;

bool get firebaseAvailable {
  final value = _firebase;
  return value != null && !value.isUndefinedOrNull;
}

FirebaseJs get firebase => _firebase!;

class FirebaseClient {
  String? uid;
  bool _ready = false;
  bool _analyticsReady = false;
  bool _emulatorsConnected = false;
  String? _screen;

  bool get usingLocalEmulators {
    final host = web.window.location.hostname;
    return host == 'localhost' || host == '127.0.0.1';
  }

  void startAnalytics() {
    if (!firebaseAvailable) return;
    try {
      _ensureApp();
    } catch (_) {}
  }

  void logScreen(String path) {
    if (path.isEmpty || path == _screen) return;
    _screen = path;
    _logEvent('screen_view', {'firebase_screen': path});
  }

  void logDataReceived({
    required bool hdsCloud,
    required String dataType,
    required String dataSource,
  }) {
    _logEvent('data_received', {
      'hds_cloud_enabled': hdsCloud,
      'data_type': dataType,
      'data_source': dataSource,
    });
  }

  Future<void> ensureSignedIn() async {
    if (!firebaseAvailable) {
      throw StateError('Firebase failed to load');
    }
    _ensureApp();
    if (usingLocalEmulators) _connectEmulators();

    final auth = firebase.auth();
    try {
      await auth.authStateReady().toDart;
    } catch (_) {
      // Older compatibility builds resolve the user through currentUser only.
    }
    uid = auth.currentUser?.uid;
    if (uid != null) return;

    await auth.signInAnonymously().toDart;
    uid = auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Anonymous sign-in did not return a user');
    }
  }

  void _ensureApp() {
    if (_ready) return;
    if (!firebaseAvailable) {
      throw StateError('Firebase failed to load');
    }
    try {
      firebase.initializeApp(
        FirebaseOptions(
          apiKey: firebaseApiKey,
          authDomain: firebaseAuthDomain,
          databaseURL: firebaseDatabaseUrl,
          projectId: firebaseProjectId,
          storageBucket: firebaseStorageBucket,
          messagingSenderId: firebaseMessagingSenderId,
          appId: firebaseAppId,
          measurementId: firebaseMeasurementId,
        ),
      );
    } catch (error) {
      if (!'$error'.contains('already exists')) rethrow;
    }
    _ready = true;
    _enableAnalytics();
  }

  void _enableAnalytics() {
    if (_analyticsReady) return;
    try {
      firebase.analytics();
      _analyticsReady = true;
    } catch (_) {}
  }

  void _logEvent(String name, Map<String, Object> parameters) {
    if (!_analyticsReady) return;
    final params = JSObject();
    for (final MapEntry(:key, :value) in parameters.entries) {
      params[key] = switch (value) {
        final bool item => item.toJS,
        final num item => item.toJS,
        final String item => item.toJS,
        _ => '$value'.toJS,
      };
    }
    try {
      firebase.analytics().logEvent(name, params);
    } catch (_) {}
  }

  void _connectEmulators() {
    if (_emulatorsConnected) return;
    try {
      firebase.auth().useEmulator('http://127.0.0.1:9099');
    } catch (error) {
      if (!_emulatorAlreadyConfigured(error)) rethrow;
    }
    try {
      firebase.database().useEmulator('127.0.0.1', 9000);
    } catch (error) {
      if (!_emulatorAlreadyConfigured(error)) rethrow;
    }
    _emulatorsConnected = true;
  }

  bool _emulatorAlreadyConfigured(Object error) =>
      '$error'.toLowerCase().contains('already');
}

@JS()
@anonymous
extension type FirebaseOptions._(JSObject _) implements JSObject {
  external factory FirebaseOptions({
    required String apiKey,
    required String authDomain,
    required String databaseURL,
    required String projectId,
    required String storageBucket,
    required String messagingSenderId,
    required String appId,
    required String measurementId,
  });
}

extension type FirebaseJs._(JSObject _) implements JSObject {
  external void initializeApp(FirebaseOptions options);
  external FirebaseAnalytics analytics();
  external FirebaseAuth auth();
  external FirebaseDatabase database();
}

extension type FirebaseAnalytics._(JSObject _) implements JSObject {
  external void logEvent(String name, [JSObject? params]);
}

extension type FirebaseAuth._(JSObject _) implements JSObject {
  external User? get currentUser;
  external void useEmulator(String url);
  external JSPromise<JSAny?> signInAnonymously();
  external JSPromise<JSAny?> authStateReady();
}

extension type User._(JSObject _) implements JSObject {
  external String get uid;
}

extension type FirebaseDatabase._(JSObject _) implements JSObject {
  external void useEmulator(String host, int port);
  external DatabaseReference ref([String? path]);
}

extension type DatabaseReference._(JSObject _) implements JSObject {
  external DatabaseReference child(String path);
  external JSPromise<JSAny?> set(JSAny? value);
  external JSPromise<JSAny?> once(String eventType);
  external void on(String eventType, JSFunction callback);
  external void off([String? eventType, JSFunction? callback]);
}

extension type DataSnapshot(JSObject _) implements JSObject {
  external JSAny? val();
  external bool exists();
}
