import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/volunteer_opportunity.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final VolunteerOpportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A FloatingActionButton is a classic Material Design element for a primary action
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Placeholder for sign-up logic
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Registration'),
              content: const Text('Thank you for your interest! This feature will be available soon.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        label: const Text('Sign Up to Volunteer'),
        icon: const Icon(Icons.how_to_reg),
        backgroundColor: Colors.green[800],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                opportunity.name,
                style: const TextStyle(shadows: [Shadow(color: Colors.black54, blurRadius: 8)]),
              ),
              background: Image.asset(
                opportunity.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80), // Add padding for FAB
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Using ListTile for better alignment and standard look
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opportunity.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}