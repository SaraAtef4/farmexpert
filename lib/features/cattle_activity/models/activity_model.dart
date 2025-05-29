
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CattleActivityEvent {
  final int? cattleId;
  final String eventType;
  final DateTime date;
  final String notes;
  final bool isIndividual;
  final Map<String, dynamic>? additionalData;

  CattleActivityEvent({
    this.cattleId,
    required this.eventType,
    required this.date,
    required this.notes,
    required this.isIndividual,
    this.additionalData,
  });
// individual event types
  static const List<String> individualEventTypes = [
    'Dry off',
    'Treated/Medicated',
    'Inseminated/Mated',
    'Weighted',
    'Gives Birth',
    'Vaccinated',
    'Pregnant',
    'Aborted Pregnancy',
    'Deworming',
    'Hoof Trimming',
    'Other',
  ];
  // Group event types
  static const List<String> groupEventTypes = [
    'Vaccination/Injection',
    'Heed spraying',
    'Deworming',
    'Treatment/Medication',
    'Hoof Trimming',
    'Tagging',
    'Other',
  ];
  // get event type based on individual/group selection
  static List<String> getEventTypes(bool isIndividual) {
    return isIndividual ? individualEventTypes : groupEventTypes;
  }

  Color getEventColor() {
    switch (eventType.toLowerCase()) {
      case 'vaccinated':
        return Colors.green;

      case 'pregnent':
        return Colors.purple;
      case 'inseminated/mated':
        return Colors.pink;
      case 'gives birth':
        return Colors.orange;
      case 'heat detection':
        return Colors.red;
      case 'feeding':
        return Colors.amber;
      case 'weighted':
        return Colors.teal;
      case 'treated/medicated':
        return Colors.cyan;
      case 'hoof trimming':
        return Colors.deepOrange;
      case 'pregnant':
        return Colors.indigo;
      case 'aborted pregnancy':

        return Colors.lightGreen;
      case 'dry off':
        return Colors.grey;
      default:
        return Colors.brown;
    }
  }

  String get formattedDate {
    return DateFormat('yyyy-MM-dd').format(date);
  }

}