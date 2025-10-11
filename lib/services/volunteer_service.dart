import '../models/volunteer_opportunity.dart';

class VolunteerService {
  // This is a placeholder for a future API call.
  Future<List<VolunteerOpportunity>> getOpportunities() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      VolunteerOpportunity(
        id: '1',
        name: 'Beach Cleanup',
        date: DateTime(2025, 10, 20),
        location: 'Goa Beach',
        description: 'Help clean up plastic waste and restore the coastline. We will provide gloves, bags, and refreshments. Join us to make a tangible impact on our beautiful shores.',
        category: 'Environment',
        imageUrl: 'assets/images/beach_cleanup.jpg',
      ),
      VolunteerOpportunity(
        id: '2',
        name: 'Community Library Setup',
        date: DateTime(2025, 11, 5),
        location: 'City Hall',
        description: 'Arrange books and set up a library for underprivileged kids. Help us categorize, shelve, and create a welcoming space for young readers.',
        category: 'Education',
        imageUrl: 'assets/images/library.jpg',
      ),
      VolunteerOpportunity(
        id: '3',
        name: 'Tree Plantation Drive',
        date: DateTime(2025, 11, 15),
        location: 'Green Park',
        description: 'Plant 100+ saplings in the local park. We aim to increase the green cover of our city and combat pollution. All tools will be provided.',
        category: 'Environment',
        imageUrl: 'assets/images/tree_plantation.jpg',
      ),
    ];
  }
}