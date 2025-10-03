import 'package:flutter/material.dart';

class OpportunitiesScreen extends StatelessWidget {
  const OpportunitiesScreen({super.key});

  // Helper method to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Environment':
        return Icons.eco;
      case 'Education':
        return Icons.menu_book;
      case 'Charity':
        return Icons.favorite;
      default:
        return Icons.campaign;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Static data for the list
    final List<Map<String, String>> events = [
      {
        'name': 'Beach Cleanup',
        'date': '20 Oct 2025',
        'location': 'Goa Beach',
        'description': 'Help clean up plastic waste and restore the coastline.',
        'category': 'Environment',
      },
      {
        'name': 'Community Library Setup',
        'date': '5 Nov 2025',
        'location': 'City Hall',
        'description': 'Arrange books and set up a library for underprivileged kids.',
        'category': 'Education',
      },
      {
        'name': 'Tree Plantation Drive',
        'date': '15 Nov 2025',
        'location': 'Green Park',
        'description': 'Plant 100+ saplings in the local park.',
        'category': 'Environment',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteering Opportunities'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          event['name']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Icon(_getCategoryIcon(event['category']!)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(event['date']!),
                      const SizedBox(width: 20),
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(event['location']!),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(event['description']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}