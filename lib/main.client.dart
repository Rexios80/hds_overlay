import 'package:jaspr/client.dart';
import 'package:web/web.dart' as web;

import 'app.dart';
import 'main.client.options.dart';
import 'store.dart';

void main() {
  Jaspr.initializeApp(options: defaultClientOptions);
  _adoptLegacyHashRoute();
  _start();
}

void _adoptLegacyHashRoute() {
  final hash = web.window.location.hash;
  if (hash.length > 1 && hash.startsWith('#/')) {
    web.window.history.replaceState(null, '', hash.substring(1));
  }
}

Future<void> _start() async {
  final store = await AppStore.open();
  runApp(App(store: store));
}
