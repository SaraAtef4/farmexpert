class AddEventCattleActivityINDResponse {
  final String message;
  final EventData eventData;

  AddEventCattleActivityINDResponse({required this.message, required this.eventData});

  factory AddEventCattleActivityINDResponse.fromJson(Map<String, dynamic> json) {
    return AddEventCattleActivityINDResponse(
      message: json['message'],
      eventData: EventData.fromJson(json['eventData']),
    );
  }
}

// class EventData {
//   final int id;
//   final String EventType;
//   final int tagNumber;
//   final String? medicine;
//   final String? dosage;
//   final String? withdrawalTime;
//   final String date;
//
//   EventData({
//     required this.id,
//     required this.EventType,
//     required this.tagNumber,
//     this.medicine,
//     this.dosage,
//     this.withdrawalTime,
//     required this.date,
//   });
//
//   factory EventData.fromJson(Map<String, dynamic> json) {
//     return EventData(
//       id: json['id'],
//       EventType: json['EventType'],
//       tagNumber: json['tagNumber'],
//       medicine: json['medicine'],
//       dosage: json['dosage'],
//       withdrawalTime: json['withdrawalTime'],
//       date: json['date'],
//     );
//   }
// }

class EventData {
  final int? id;
  final String? EventType;
  final int? tagNumber;
  final String? medicine;
  final String? dosage;
  final String? withdrawalTime;
  final String? date;

  EventData({
    this.id,
    this.EventType,
    this.tagNumber,
    this.medicine,
    this.dosage,
    this.withdrawalTime,
    this.date,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] as int?,
      EventType: json['EventType'] as String?,
      tagNumber: json['tagNumber'] as int?,
      medicine: json['medicine'] as String?,
      dosage: json['dosage'] as String?,
      withdrawalTime: json['withdrawalTime'] as String?,
      date: json['date'] as String?,
    );
  }
}
