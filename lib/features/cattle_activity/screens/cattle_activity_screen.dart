import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_floating_button.dart';
import '../../../data/providers/cattle_events_provider.dart';
import '../models/activity_model.dart';
import '../widgets/event_list_item.dart';
import '../widgets/no_events_placeholder.dart';
import 'add_event_screen.dart';
import 'filter_events_screen.dart';

class CattleActivityScreen extends StatefulWidget {
  const CattleActivityScreen({Key? key}) : super(key: key);

  @override
  State<CattleActivityScreen> createState() => _CattleActivityScreenState();
}

class _CattleActivityScreenState extends State<CattleActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios,color: Colors.white,),
        title:  Text(
          'Cattle Activities',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs:  [
            Tab(
              icon: Icon(Icons.pets),
              text: 'Individual',
            ),
            Tab(
              icon: ImageIcon(AssetImage('assets/images/group2.png'),size: 45,),
              text: 'Mass',
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white,size: 28,),
            tooltip: 'Filter Events',
            onPressed: () {
              showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Individual events tab
          _buildEventsList(isIndividual: true),
          // Group events tab
          _buildEventsList(isIndividual: false),
        ],
      ),
      floatingActionButton: CustomFloatingButton(onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEventScreen(
              isIndividual: _tabController.index == 0,
            ),
          ),
        );
      },)
    );
  }

  Widget _buildEventsList({required bool isIndividual}) {
    return Consumer<CattleEventsProvider>(
      builder: (context, provider, child) {
        final filteredEvents = provider.getFilteredEvents(isIndividual: isIndividual);

        if (filteredEvents.isEmpty) {
          return NoEventsPlaceholder(isIndividual: isIndividual);
        }

        // Group events by date for better organization
        final Map<String, List<CattleActivityEvent>> groupedEvents = {};
        for (var event in filteredEvents) {
          final dateStr = event.formattedDate;
          if (!groupedEvents.containsKey(dateStr)) {
            groupedEvents[dateStr] = [];
          }
          groupedEvents[dateStr]!.add(event);
        }

        // Sort dates in descending order (newest first)
        final sortedDates = groupedEvents.keys.toList()
          ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

        return ListView.builder(
          itemCount: sortedDates.length,
          padding:  EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final dateEvents = groupedEvents[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      Container(
                        padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          date,
                          style:  TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                       SizedBox(width: 8),
                      Text(
                        '${dateEvents.length} events',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ...dateEvents.map((event) => ActivityEntryCard(event: event, onEdit: () {  },  onDelete: () {
                  Provider.of<CattleEventsProvider>(context, listen: false).deleteEvent(event);
                },)).toList(),
                 SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}

