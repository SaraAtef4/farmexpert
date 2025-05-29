import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/cattle_events_provider.dart';

class NoEventsPlaceholder extends StatelessWidget {
  final bool isIndividual;

   NoEventsPlaceholder({Key? key, required this.isIndividual}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CattleEventsProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(Icons.event_busy, size: 80, color: Colors.grey),
           SizedBox(height: 16),
          Text(
            isIndividual ? 'No individual events' : 'No group events',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          if (provider.hasActiveFilters())
            TextButton(
              onPressed: () => provider.clearFilters(),
              child:  Text('Remove filters'),
            ),
        ],
      ),
    );
  }
}