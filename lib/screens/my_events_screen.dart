import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_connect/models/volunteer_opportunity.dart';
import 'package:volunteer_connect/services/volunteer_service.dart';
import 'package:volunteer_connect/screens/opportunity_detail_screen.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Future<List<VolunteerOpportunity>> _myEventsFuture;
  final VolunteerService _volunteerService = VolunteerService();

  @override
  void initState() {
    super.initState();
    _myEventsFuture = _volunteerService.getMyRegisteredEvents();
  }

  // Re-used from opportunities_screen to maintain a consistent style
  Widget _buildOpportunityListItem(VolunteerOpportunity event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpportunityDetailScreen(opportunity: event),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Image.network(
            event.imageUrl,
            height: 120,
            width: 110,
            fit: BoxFit.cover,
            // Add a loading builder
            loadingBuilder: (context, child, progress) {
              return progress == null
                  ? child
                  : const SizedBox(
                      height: 120,
                      width: 110,
                      child: Center(child: CircularProgressIndicator()));
            },
            // Add an error builder
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                width: 110,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey[400]),
              );
            },
          ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('d MMM yyyy').format(event.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Registered Events'),
      ),
      body: FutureBuilder<List<VolunteerOpportunity>>(
        future: _myEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have not registered for any events yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final myEvents = snapshot.data!;

          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: myEvents.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildOpportunityListItem(myEvents[index]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}