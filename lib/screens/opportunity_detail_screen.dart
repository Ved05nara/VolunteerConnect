import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_connect/services/auth_service.dart';
import 'package:volunteer_connect/services/volunteer_service.dart';
import '../models/volunteer_opportunity.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final VolunteerOpportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    // Helper widget to build the info rows consistently
    Widget buildInfoRow(IconData icon, String text) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      // Use bottomNavigationBar to pin the button to the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.how_to_reg),
          label: const Text('Sign Up to Volunteer'),
          onPressed: () async {
            final service = VolunteerService();
            final result = await service.signUpForOpportunity(opportunity.id);

            if (context.mounted) {
              if (result == 'Success') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully registered for the event!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (result == 'Already Registered') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are already registered for this event.'),
                    backgroundColor: Colors.blue,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result), // Shows the error message
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // Use a Column for the main layout
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Section (Info + Image) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Left Side (Text Info) ---
                Expanded(
                  flex: 3, // Takes 3/5 of the space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(opportunity.category),
                        backgroundColor: Colors.green.shade100,
                        side: BorderSide.none,
                      ),
                      const SizedBox(height: 20),
                      buildInfoRow(
                        Icons.calendar_today,
                        DateFormat('EEE, d MMMM yyyy').format(opportunity.date),
                      ),
                      const SizedBox(height: 16),
                      buildInfoRow(
                        Icons.location_on,
                        opportunity.location,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // --- Right Side (Image) ---
                Expanded(
                  flex: 2, // Takes 2/5 of the space
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      opportunity.imageUrl,
                      fit: BoxFit.cover,
                      height: 180, // Constrain the image height
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            // --- Bottom Section (Description) ---
            Text(
              'About this opportunity',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Make only the description scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  opportunity.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 8), // Padding above the button
          ],
        ),
      ),
    );
  }
}