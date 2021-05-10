import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/firestore_constants.dart';

class FirebaseUtils {
  late final FirebaseMessaging _messaging;
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  late final String _fcmToken;

  late final FirebaseController _firebase;

  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    // Must be called every time or messaging will not work on web
    _fcmToken = await _messaging.getToken(
            vapidKey:
                "BO61mOhL_8RYP8ZWZrtocxjcIO4puNDzJWXx63kHyGhxpAxAgC_B4EOpTRFKtcyKdFbTdKUCrdq2wF7H-D6jsWY") ??
        '';

    _setUp();

    return Future.value();
  }

  Future<void> _setUp() async {
    await _setUpAccount();
    await _setUpOverlay();
  }

  Future<void> _setUpAccount() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();

      final userDoc = await _firestore
          .collection(FirestorePaths.users)
          .doc(_auth.currentUser?.uid)
          .get();

      if (!userDoc.exists) {
        print('Create user doc');
        // Create a new user doc
        await userDoc.reference.set({
          UserFields.isSubscribed: false,
          UserFields.lastSubCheck: Timestamp.now(),
          UserFields.overlays: []
        });
      }
    }
  }

  Future<void> _setUpOverlay() async {
    _firebase = Get.find();

    final userDoc = await _firestore
        .collection(FirestorePaths.users)
        .doc(_auth.currentUser?.uid)
        .get();

    final List<dynamic> userOverlays = userDoc.data()?[UserFields.overlays];

    if (userOverlays.contains(_firebase.config.overlayId)) {
      // This overlay is already set up
      return;
    }

    // This should hopefully never happen
    if (_fcmToken.isEmpty || _auth.currentUser == null) return;

    await _createOverlayDoc(_fcmToken);
  }

  Future<void> _createOverlayDoc(String fcmToken) async {
    print('_createOverlayDoc(${_firebase.config.overlayId})');

    final overlayDocRef = _firestore
        .collection(FirestorePaths.overlays)
        .doc(_firebase.config.overlayId);

    // Create the overlay doc
    overlayDocRef.set({
      OverlayFields.fcmToken: fcmToken,
      OverlayFields.uid: _auth.currentUser?.uid,
    }).then((value) {
      // Success
      print('Update user overlays');
      // Add the overlay reference to the user doc
      _firestore
          .collection(FirestorePaths.users)
          .doc(_auth.currentUser?.uid)
          .set({
        UserFields.overlays:
            FieldValue.arrayUnion([_firebase.config.overlayId]),
      }, SetOptions(merge: true));
    }).onError((error, stackTrace) {
      // Epic fail
      // An overlay with that ID must already exist
      print(error);
      print(stackTrace);

      // So let's try again
      _firebase.config.generateOverlayId();
      _createOverlayDoc(fcmToken);
    });
  }
}