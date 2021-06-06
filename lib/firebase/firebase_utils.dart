// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';

class FirebaseUtils {
  final ConnectionController connectionController = Get.find();
  late final auth;

  void init() {
    if (apps.isEmpty) {
      final dbUrl;
      if (kDebugMode) {
        dbUrl = 'http://localhost:9000/?ns=health-data-server-default-rtdb';
      } else {
        dbUrl = 'https://health-data-server-default-rtdb.firebaseio.com';
      }
      initializeApp(
        apiKey: "AIzaSyCbbBPvlWvmOvI6Is8PYXNpJ78N03AYcyU",
        authDomain: "health-data-server.firebaseapp.com",
        databaseURL: dbUrl,
        projectId: "health-data-server",
        storageBucket: "health-data-server.appspot.com",
        messagingSenderId: "47929674141",
        appId: "1:47929674141:web:0606fd3354256f51860774",
        measurementId: "G-1V10QYSSHG",
      );

      print('firebaseAppCheck');
      js.context.callMethod('firebaseAppCheck');
    }

    auth = FirebaseAuth.instance;
    if (kDebugMode) {
      auth.useEmulator("http://localhost:9099");
    }
  }

  Future<void> signIn() async {
    print('Starting Firebase authorization');
    if (auth.currentUser == null) {
      print('Not authenticated, signing in');
      await auth.signInAnonymously();
      print('User is authenticated as: ${auth.currentUser?.uid}');
    } else {
      print('User is already authenticated');
    }
  }

  Future<String> getIdToken() async {
    return await auth.currentUser?.getIdToken(true) ?? '';
  }
}
