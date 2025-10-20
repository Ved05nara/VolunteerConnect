import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- 1. ADD THIS IMPORT

class AuthService {
  // Get an instance of Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // <-- 2. ADD THIS LINE
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP METHOD
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // 1. Create the user in Firebase Auth
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Update the Auth profile's display name (optional, but good to have)
        await user.updateDisplayName(fullName);
        await user.reload();

        // 3. Create a new document in the 'users' collection in Firestore
        // This will now work because _firestore is defined
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email.trim(),
          'uid': user.uid,
          // This will now work because Timestamp is imported
          'createdAt': Timestamp.now(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
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
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      return null;
    }
  }

  // SIGN OUT METHOD
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}