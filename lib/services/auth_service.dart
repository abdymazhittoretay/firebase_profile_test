import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  User? get currentUser => _instance.currentUser;
  Stream<User?> get authStateChange => _instance.authStateChanges();

  Future<void> registerUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
