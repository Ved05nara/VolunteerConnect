import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/volunteer_opportunity.dart';

class VolunteerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches ALL opportunities
  Future<List<VolunteerOpportunity>> getOpportunities() async {
    try {
      final snapshot =
          await _firestore.collection('opportunities').orderBy('date').get();

      final opportunities = snapshot.docs.map((doc) {
        final data = doc.data();
        return VolunteerOpportunity(
          id: doc.id,
          name: data['name'] ?? 'No Name',
          date: (data['date'] as Timestamp).toDate(),
          location: data['location'] ?? 'No Location',
          description: data['description'] ?? 'No Description',
          category: data['category'] ?? 'General',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();

      return opportunities;
    } catch (e) {
      print("Error fetching opportunities: $e");
      return [];
    }
  }

  // Signs a user up for an event
  Future<String> signUpForOpportunity(String opportunityId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Error: You must be logged in to register.';
    }

    try {
      final querySnapshot = await _firestore
          .collection('registrations')
          .where('userId', isEqualTo: user.uid)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'Already Registered';
      }

      await _firestore.collection('registrations').add({
        'userId': user.uid,
        'opportunityId': opportunityId,
        'registrationDate': Timestamp.now(),
      });

      return 'Success';
    } catch (e) {
      print("Error signing up for opportunity: $e");
      return 'Error: An unexpected error occurred.';
    }
  }

  // Checks if a user is registered
  Future<bool> isUserRegistered(String opportunityId) async {
    // ... (your existing isUserRegistered method)
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final querySnapshot = await _firestore
          .collection('registrations')
          .where('userId', isEqualTo: user.uid)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking registration status: $e");
      return false;
    }
  }

  // *** NEW METHOD TO ADD ***
  // Fetches only the events the current user is registered for
  Future<List<VolunteerOpportunity>> getMyRegisteredEvents() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return []; // Not logged in, so no registered events
    }

    try {
      // 1. Find all registrations for the current user
      final regSnapshot = await _firestore
          .collection('registrations')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (regSnapshot.docs.isEmpty) {
        return []; // User has no registrations
      }

      // 2. Extract the list of opportunity IDs from the registrations
      final opportunityIds = regSnapshot.docs
          .map((doc) => doc.data()['opportunityId'] as String)
          .toList();

      // 3. Fetch all opportunities whose IDs are in our list
      // Note: A 'whereIn' query is limited to 30 items.
      final oppSnapshot = await _firestore
          .collection('opportunities')
          .where(FieldPath.documentId, whereIn: opportunityIds)
          .get();

      // 4. Map the documents to the VolunteerOpportunity model
      return oppSnapshot.docs.map((doc) {
        final data = doc.data();
        return VolunteerOpportunity(
          id: doc.id,
          name: data['name'] ?? 'No Name',
          date: (data['date'] as Timestamp).toDate(),
          location: data['location'] ?? 'No Location',
          description: data['description'] ?? 'No Description',
          category: data['category'] ?? 'General',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      print("Error fetching registered events: $e");
      return [];
    }
  }
}