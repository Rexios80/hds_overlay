import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/firestore_constants.dart';

class FirebaseUtils {
  late FirebaseMessaging _messaging;
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  late String _fcmToken;

  final FirebaseController _firebase = Get.find();

  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    return _messaging.requestPermission().then((value) async {
      print('User allowed permission for notifications');
      print('Requesting FCM token');

      // Must be called every time or messaging will not work on web
      _fcmToken = await _messaging.getToken(
              vapidKey:
                  'BO61mOhL_8RYP8ZWZrtocxjcIO4puNDzJWXx63kHyGhxpAxAgC_B4EOpTRFKtcyKdFbTdKUCrdq2wF7H-D6jsWY') ??
          '';
      print('FCM token received: $_fcmToken');
      _firebase.fcmRegistered.value = true;
      _setUp();
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      print('User denied permission for notifications');
    });
  }

  Future<void> _setUp() async {
    await _setUpAccount();
    await _setUpOverlay();
  }

  Future<void> _setUpAccount() async {
    print('Starting Firebase authorization');
    if (_auth.currentUser == null) {
      print('Not authenticated, signing in');
      await _auth.signInAnonymously();
      print('User is authenticated as: ${_auth.currentUser?.uid}');

      print('Creating user doc');
      final userDoc = await _firestore
          .collection(FirestorePaths.users)
          .doc(_auth.currentUser?.uid)
          .get();

      if (!userDoc.exists) {
        print('User doc does not exist');
        print('Create user doc');
        // Create a new user doc
        await userDoc.reference.set({
          UserFields.isSubscribed: false,
          UserFields.lastSubCheck: Timestamp.now(),
          UserFields.overlays: []
        });
      }
    } else {
      print('User is already authenticated');
    }
  }

  Future<void> _setUpOverlay() async {
    print('Fetching user doc');
    final userDoc = await _firestore
        .collection(FirestorePaths.users)
        .doc(_auth.currentUser?.uid)
        .get();

    final List<dynamic> userOverlays = userDoc.data()?[UserFields.overlays];

    if (userOverlays.contains(_firebase.config.overlayId)) {
      print('Overlay is already set up');
      // This overlay is already set up
      return;
    }

    // This should hopefully never happen
    if (_fcmToken.isEmpty || _auth.currentUser == null) {
      print('FCM token is empty or user is not authenticated');
      return;
    }

    await _createOverlayDoc(_fcmToken);
  }

  Future<void> _createOverlayDoc(String fcmToken) async {
    print('Creating doc for overlay id ${_firebase.config.overlayId}');

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
