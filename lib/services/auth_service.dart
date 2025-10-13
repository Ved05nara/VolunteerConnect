import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Get an instance of Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // SIGN UP METHOD
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName, // You can store this in Firestore later
  }) async {
    try {
      // This will create the user in Firebase Authentication
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // You can also update the user's display name
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // If there's an error (e.g., email already in use), print it and return null
      print("Error signing up: ${e.message}");
      return null;
    }
  }

  // SIGN IN METHOD
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // This will sign in the user
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // If there's an error (e.g., wrong password), print it and return null
      print("Error signing in: ${e.message}");
      return null;
    }
  }

  // SIGN OUT METHOD
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}