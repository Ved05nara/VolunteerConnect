import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:volunteer_connect/services/auth_service.dart';
import '../models/volunteer_opportunity.dart';
import '../services/volunteer_service.dart';
import 'opportunity_detail_screen.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  final VolunteerService _volunteerService = VolunteerService();
  late Future<List<VolunteerOpportunity>> _opportunitiesFuture;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _opportunitiesFuture = _volunteerService.getOpportunities();
  }

  // WIDGET for the category filter chips
  Widget _buildCategoryFilters() {
    const categories = ['All', 'Environment', 'Education', 'Health', 'Community'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.green[100],
              selectedColor: Colors.green[800],
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  // NEW WIDGET for a list item
  Widget _buildOpportunityListItem(VolunteerOpportunity event) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OpportunityDetailScreen(opportunity: event)));
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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

  // WIDGET for shimmer loading effect
  Widget _buildShimmeringList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const SizedBox(height: 120, width: double.infinity),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220.0,
            // Added logout button here
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Sign Out',
                onPressed: () => AuthService().signOut(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.green.shade500],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('logo.png', height: 80, fit: BoxFit.contain),
                      const SizedBox(height: 10),
                      Text('VolunteerConnect',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Connecting volunteers, empowering communities",
                          style: GoogleFonts.lato(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoryFilters()),
          FutureBuilder<List<VolunteerOpportunity>>(
            future: _opportunitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: SizedBox(height: 500, child: _buildShimmeringList()),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Center(child: Text('Error: ${snapshot.error}')));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Center(child: Text('No opportunities found.')));
              }

              final allOpportunities = snapshot.data!;
              final filteredOpportunities = _selectedCategory == 'All'
                  ? allOpportunities
                  : allOpportunities
                      .where((op) => op.category == _selectedCategory)
                      .toList();

              // CHANGED to SliverList for the new layout
              return AnimationLimiter(
                child: SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildOpportunityListItem(
                                  filteredOpportunities[index]),
                            ),
                          ),
                        );
                      },
                      childCount: filteredOpportunities.length,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}