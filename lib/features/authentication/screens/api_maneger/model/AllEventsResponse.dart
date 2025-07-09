// class AllEventsResponse {
//   final int id;
//   final String eventType;
//   final int tagNumber;
//   final String? medicine;
//   final String? dosage;
//   final String? withdrawalTime;
//   final String? notes;
//   final String? calfGender;
//   final int? weight;
//   final String date;
//
//   AllEventsResponse({
//     required this.id,
//     required this.eventType,
//     required this.tagNumber,
//     this.medicine,
//     this.dosage,
//     this.withdrawalTime,
//     this.notes,
//     this.calfGender,
//     this.weight,
//     required this.date,
//   });
//
//   factory AllEventsResponse.fromJson(Map<String, dynamic> json) {
//     return AllEventsResponse(
//       id: json['id'],
//       eventType: json['eventType'],
//       tagNumber: json['tagNumber'],
//       medicine: json['medicine'],
//       dosage: json['dosage'],
//       withdrawalTime: json['withdrawalTime'],
//       notes: json['notes'],
//       calfGender: json['calfGender'],
//       weight: json['weight'],
//       date: json['date'],
//     );
//   }
// }

import 'package:flutter/material.dart';

class AllEventsResponse {
  final int id;
  final String eventType;
  final int tagNumber;
  final String? medicine;
  final String? dosage;
  final String? withdrawalTime;
  final String? notes;
  final String? calfGender;
  final int? weight;
  final String date;

  AllEventsResponse({
    required this.id,
    required this.eventType,
    required this.tagNumber,
    this.medicine,
    this.dosage,
    this.withdrawalTime,
    this.notes,
    this.calfGender,
    this.weight,
    required this.date,
  });

  factory AllEventsResponse.fromJson(Map<String, dynamic> json) {
    return AllEventsResponse(
      id: json['id'],
      eventType: json['eventType'],
      tagNumber: json['tagNumber'],
      medicine: json['medicine'],
      dosage: json['dosage'],
      withdrawalTime: json['withdrawalTime'],
      notes: json['notes'],
      calfGender: json['calfGender'],
      weight: json['weight'],
      date: json['date'],
    );
  }

  /// 🔵 لون الحدث حسب النوع
  Color getEventColor() {
    switch (eventType.toLowerCase()) {
      case 'gives birth':
        return Colors.pink;
      case 'weighted':
        return Colors.blue;
      case 'treated':
        return Colors.orange;
      case 'vaccinated':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// 🔵 أيقونة الحدث حسب النوع
  IconData getEventIcon() {
    switch (eventType.toLowerCase()) {
      case 'gives birth':
        return Icons.child_friendly;
      case 'weighted':
        return Icons.monitor_weight;
      case 'treated':
        return Icons.healing;
      case 'vaccinated':
        return Icons.vaccines;
      default:
        return Icons.event_note;
    }
  }
}

