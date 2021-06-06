// This makes the compiler happy for non web clients
class FirebaseUtils {
  void init() {}
  Future<void> signIn() async {}
  Future<String> getIdToken() async {
    throw UnimplementedError();
  }
}
