import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseUtils {
  late final FirebaseMessaging _messaging;

  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    String token = await _messaging.getToken(
          vapidKey:
              "BO61mOhL_8RYP8ZWZrtocxjcIO4puNDzJWXx63kHyGhxpAxAgC_B4EOpTRFKtcyKdFbTdKUCrdq2wF7H-D6jsWY",
        ) ??
        '';

    return Future.value();
  }
}
