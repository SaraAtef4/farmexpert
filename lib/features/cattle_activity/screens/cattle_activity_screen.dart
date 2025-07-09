import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_floating_button.dart';
import '../../../data/providers/cattle_events_provider.dart';
import '../../../features/authentication/screens/api_maneger/model/AllEventsResponse.dart';
import '../widgets/event_list_item.dart';
import '../widgets/no_events_placeholder.dart';
import 'add_event_screen.dart';
import 'filter_events_screen.dart';

class CattleActivityScreen extends StatefulWidget {
  const CattleActivityScreen({Key? key}) : super(key: key);

  @override
  State<CattleActivityScreen> createState() => _CattleActivityScreenState();
}

class _CattleActivityScreenState extends State<CattleActivityScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<CattleEventsProvider>(context, listen: false)
          .fetchAllEventsFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, color: Colors.white),
        title: Text('Cattle Activities',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.w500)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined,
                color: Colors.white, size: 28),
            tooltip: 'Filter Events',
            onPressed: () => showFilterBottomSheet(context),
          ),
        ],
      ),
      body: _buildEventsList(),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEventScreen(isIndividual: true),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Consumer<CattleEventsProvider>(
      builder: (context, provider, child) {
        final events = provider.getFilteredEvents();

        if (events.isEmpty) {
          return NoEventsPlaceholder(isIndividual: true);
        }

        final Map<String, List<AllEventsResponse>> groupedEvents = {};
        for (var event in events) {
          final dateStr = event.date.split('T').first;
          groupedEvents.putIfAbsent(dateStr, () => []).add(event);
        }

        final sortedDates = groupedEvents.keys.toList()
          ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

        return ListView.builder(
          itemCount: sortedDates.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final dateEvents = groupedEvents[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          date,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${dateEvents.length} events',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ...dateEvents.map((event) => ActivityEntryCard(
                      event: event,
                      onDelete: () => provider.deleteEventFromApi(event.id),
                    )),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}
