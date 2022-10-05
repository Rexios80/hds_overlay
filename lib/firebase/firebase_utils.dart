import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/firebase_options.dart';
import 'package:logger/logger.dart';

class FirebaseUtils {
  final _logger = Get.find<Logger>();

  final ConnectionController connectionController = Get.find();
  late final FirebaseAuth _auth;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _auth = FirebaseAuth.instance;
    if (!kReleaseMode) {
      try {
        await _auth.useAuthEmulator('localhost', 9099);
        FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
      } catch (e) {
        _logger.e(e);
      }
    }
  }

  Future<void> signIn() async {
    _logger.d('Starting Firebase authorization');
    if (_auth.currentUser == null) {
      _logger.d('Not authenticated, signing in');
      await _auth.signInAnonymously();
      _logger.d('User is authenticated as: ${_auth.currentUser?.uid}');
    } else {
      _logger.d('User is already authenticated');
    }
  }

  Future<String> getIdToken() async {
    return await _auth.currentUser?.getIdToken(true) ?? '';
  }
}
