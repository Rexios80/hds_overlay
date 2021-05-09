import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseUtils {
  final _messaging = Get.put(FirebaseMessaging.instance);

  void init() async {
    await Firebase.initializeApp();
    String token = await _messaging.getToken(
          vapidKey:
              "BO61mOhL_8RYP8ZWZrtocxjcIO4puNDzJWXx63kHyGhxpAxAgC_B4EOpTRFKtcyKdFbTdKUCrdq2wF7H-D6jsWY",
        ) ??
        '';
  }
}
