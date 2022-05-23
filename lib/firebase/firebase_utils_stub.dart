// This makes the compiler happy for non web clients
class FirebaseUtils {
  Future<void> init() async {}
  Future<void> signIn() async {}
  Future<String> getIdToken() async {
    throw UnimplementedError();
  }
}
