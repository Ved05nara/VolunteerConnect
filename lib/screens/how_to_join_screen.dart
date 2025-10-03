import 'package:flutter/material.dart';

class HowToJoinScreen extends StatelessWidget {
  const HowToJoinScreen({super.key});

  Widget _buildStep(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.green[700]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Become a Volunteer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStep(
              context,
              icon: Icons.person_add,
              title: '1. Sign Up',
              subtitle: 'Register your name and contact details with our organization to get started.',
            ),
            const Divider(),
            _buildStep(
              context,
              icon: Icons.event,
              title: '2. Pick an Event',
              subtitle: 'Browse through our list of opportunities and choose one that you feel passionate about.',
            ),
            const Divider(),
            _buildStep(
              context,
              icon: Icons.access_time_filled,
              title: '3. Arrive On Time',
              subtitle: 'Punctuality is key. Please arrive at the specified location at least 15 minutes early.',
            ),
            const Divider(),
            _buildStep(
              context,
              icon: Icons.check_circle_outline,
              title: '4. Participate with Enthusiasm',
              subtitle: 'Engage with the community, follow the coordinator\'s lead, and make a real difference!',
            ),
          ],
        ),
      ),
    );
  }
}