import 'dart:js_interop';

import 'package:web/web.dart' as web;

const firebaseApiKey = 'AIzaSyCbbBPvlWvmOvI6Is8PYXNpJ78N03AYcyU';
const firebaseAppId = '1:47929674141:web:0606fd3354256f51860774';
const firebaseMessagingSenderId = '47929674141';
const firebaseProjectId = 'health-data-server';
const firebaseAuthDomain = 'health-data-server.firebaseapp.com';
const firebaseDatabaseUrl =
    'https://health-data-server-default-rtdb.firebaseio.com';
const firebaseStorageBucket = 'health-data-server.appspot.com';

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

  bool get usingLocalEmulators {
    final host = web.window.location.hostname;
    return host == 'localhost' || host == '127.0.0.1';
  }

  Future<void> ensureSignedIn() async {
    if (!firebaseAvailable) {
      throw StateError('Firebase failed to load');
    }
    if (!_ready) {
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
          ),
        );
      } catch (error) {
        if (!'$error'.contains('already exists')) rethrow;
      }
      if (usingLocalEmulators) _connectEmulators();
      _ready = true;
    }

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

  void _connectEmulators() {
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
  });
}

extension type FirebaseJs._(JSObject _) implements JSObject {
  external void initializeApp(FirebaseOptions options);
  external FirebaseAuth auth();
  external FirebaseDatabase database();
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
