import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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

  Widget _buildCategoryFilters() {
    const categories = ['All', 'Environment', 'Education', 'Charity'];
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
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
              backgroundColor:
                  isSelected ? Colors.green[800] : Colors.green[100],
              labelStyle:
                  TextStyle(color: isSelected ? Colors.white : Colors.black87),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOpportunityCard(VolunteerOpportunity event) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OpportunityDetailScreen(opportunity: event)));
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                event.imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey.shade700),
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
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey.shade700),
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
          ],
        ),
      ),
    );
  }

  Widget _buildShimmeringGrid(int crossAxisCount, double childAspectRatio) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(color: Colors.white),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth >= 1200) {
      crossAxisCount = 5;
      childAspectRatio = 0.95;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
      childAspectRatio = 0.85;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.9;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220.0,
            flexibleSpace: FlexibleSpaceBar(
              // The `title` property that creates the collapsing top-left text has been removed.
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
                      Image.asset(
                        'logo.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'VolunteerConnect',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Connecting volunteers, empowering communities",
                        style: GoogleFonts.lato(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
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
                  child: SizedBox(
                    height: 500,
                    child:
                        _buildShimmeringGrid(crossAxisCount, childAspectRatio),
                  ),
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

              return AnimationLimiter(
                child: SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: crossAxisCount,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _buildOpportunityCard(
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