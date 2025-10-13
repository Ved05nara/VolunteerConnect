import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_connect/services/auth_service.dart';
import '../models/volunteer_opportunity.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final VolunteerOpportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    // This widget builds the text details part of the screen
    Widget buildTextDetails() {
      return Padding(
        padding: const EdgeInsets.all(24.0),
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
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: Colors.green),
              title: Text(DateFormat('EEEE, d MMMM yyyy').format(opportunity.date)),
              subtitle: const Text('Date'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Colors.green),
              title: Text(opportunity.location),
              subtitle: const Text('Location'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'About this opportunity',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.description,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      );
    }

    // This widget builds the image part of the screen
    Widget buildImage() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              opportunity.imageUrl,
              fit: BoxFit.cover,
              // To make it responsive, we constrain its max height
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Added logout button here
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      // REPLACED FloatingActionButton with a persistent bottom button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.how_to_reg),
          label: const Text('Sign Up to Volunteer'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Registration'),
                content: const Text(
                    'Thank you for your interest! This feature will be available soon.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
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
      body: SingleChildScrollView(
        // Use LayoutBuilder to create a responsive layout
        child: LayoutBuilder(
          builder: (context, constraints) {
            // For wide screens (tablet/web), use a side-by-side layout
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: buildTextDetails()),
                  Expanded(flex: 4, child: buildImage()),
                ],
              );
            }
            // For narrow screens (mobile), stack them vertically
            else {
              return Column(
                children: [
                  buildImage(),
                  buildTextDetails(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}