import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Add this import
import 'package:volunteer_connect/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // A Future to hold our user's data
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;

  @override
  void initState() {
    super.initState();
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Initialize the Future to fetch the user's document from Firestore
      _userFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userFuture,
        builder: (context, snapshot) {
          // --- 1. LOADING STATE ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- 2. ERROR STATE ---
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Error loading profile.',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    _buildSignOutButton(),
                  ],
                ),
              ),
            );
          }

          // --- 3. SUCCESS STATE ---
          final userData = snapshot.data!.data();
          final String displayName = userData?['fullName'] ?? 'Volunteer';
          final String email = userData?['email'] ?? 'No email associated';
          final String initial =
              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'V';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      initial,
                      style:
                          TextStyle(fontSize: 50, color: Colors.green.shade800),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 48),
                  _buildSignOutButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget for the sign-out button
  Widget _buildSignOutButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Sign Out', style: TextStyle(color: Colors.white)),
      onPressed: () {
        AuthService().signOut();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}