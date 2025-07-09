import 'package:flutter/material.dart';

class MassEventResponse {
  final int id;
  final String eventType;
  final String? medicine;
  final String? dosage;
  final String? notes;
  final String date;

  MassEventResponse({
    required this.id,
    required this.eventType,
    this.medicine,
    this.dosage,
    this.notes,
    required this.date,
  });

  factory MassEventResponse.fromJson(Map<String, dynamic> json) {
    return MassEventResponse(
      id: json['id'],
      eventType: json['eventType'],
      medicine: json['medicine'],
      dosage: json['dosage'],
      notes: json['notes'],
      date: json['date'],
    );
  }

  // 🔵 لون حسب نوع الحدث
  Color getEventColor() {
    switch (eventType.toLowerCase()) {
      case 'vaccination':
        return Colors.green;
      case 'treatment':
        return Colors.orange;
      case 'heed spraying':
        return Colors.teal;
      case 'tagging':
        return Colors.indigo;
      case 'deworming':
        return Colors.brown;
      case 'hoof trimming':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
