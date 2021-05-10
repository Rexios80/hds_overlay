import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/firestore_constants.dart';

class FirebaseUtils {
  final FirebaseController _firebase = Get.find();

  late final FirebaseMessaging _messaging;
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    return Future.value();
  }

  Future<void> setUp() async {
    await setUpAccount();
    await setUpOverlay();
  }

  Future<void> setUpAccount() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();

      final userDoc = await _firestore
          .collection(FirestorePaths.users)
          .doc(_auth.currentUser?.uid)
          .get();

      if (!userDoc.exists) {
        // Create a new user doc
        await userDoc.reference.set({});
      }
    }
  }

  Future<void> setUpOverlay() async {
    final overlayDoc = await _firestore
        .collection(FirestorePaths.overlays)
        .doc(_firebase.config.overlayId)
        .get();

    if (!overlayDoc.exists) {
      final String? fcmToken = await _messaging.getToken(
          vapidKey:
              "BO61mOhL_8RYP8ZWZrtocxjcIO4puNDzJWXx63kHyGhxpAxAgC_B4EOpTRFKtcyKdFbTdKUCrdq2wF7H-D6jsWY");

      // This should hopefully never happen
      if (fcmToken == null || _auth.currentUser == null) return;

      // Create the overlay doc
      await overlayDoc.reference.set({
        OverlayFields.fcmToken: fcmToken,
        OverlayFields.uid: _auth.currentUser?.uid,
      });

      // Add the overlay reference to the user doc
      await _firestore
          .collection(FirestorePaths.users)
          .doc(_auth.currentUser?.uid)
          .set({
        UserFields.overlays: FieldValue.arrayUnion([overlayDoc.reference]),
      }, SetOptions(merge: true));
    }
  }
}
