import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/firebase_options.dart';
import 'package:hds_overlay/model/log_message.dart';
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
    if (kDebugMode) {
      await _auth.useAuthEmulator('localhost', 9099);
      FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
    } else {
      await FirebaseAppCheck.instance.activate(
        webRecaptchaSiteKey: '6LcdrdQaAAAAAHCZCIBiSKYrx56BpxzTj0MECcXx',
      );
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
