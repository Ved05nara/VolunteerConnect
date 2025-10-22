import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_connect/main.dart'; // Imports your MainScreen
import 'package:volunteer_connect/screens/landing_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to the authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is still waiting, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the snapshot has data, it means the user IS logged in
        if (snapshot.hasData) {
          return const MainScreen(); // <-- CORRECT: Show the main app
        }

        // Otherwise, the user IS NOT logged in
        return const LandingScreen(); // <-- CORRECT: Show the landing page
      },
    );
  }
}