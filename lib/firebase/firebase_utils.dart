import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/model/log_message.dart';

class FirebaseUtils {
  final ConnectionController connectionController = Get.find();

  // TODO: Convert to non-anonymous auth
  Future<void> signIn() async {
    await Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    if (kDebugMode) {
      auth.useEmulator("http://localhost:9099");
    }

    print('Starting Firebase authorization');
    if (auth.currentUser == null) {
      print('Not authenticated, signing in');
      await auth.signInAnonymously();
      print('User is authenticated as: ${auth.currentUser?.uid}');
    } else {
      print('User is already authenticated');
    }

    connectionController.logs
        .add(LogMessage(LogLevel.hdsCloud, "Connected to HDS Cloud"));
  }
}
