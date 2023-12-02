import 'package:testing/exports.dart';

class AuthService {
  const AuthService._();

  static const AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get userStream => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateName(String name) async {
    await currentUser!.updateDisplayName(name);
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    await currentUser!.updatePhotoURL(photoUrl);
  }

  Future<void> updateEmail(String email) async {
    await currentUser!.updateEmail(email);
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      final User? user = _auth.currentUser;

      final AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
