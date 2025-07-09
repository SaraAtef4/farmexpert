class AddEventCattleActivityMassResponse {
  final String? message;
  final MassEventData? eventData;

  AddEventCattleActivityMassResponse({
    this.message,
    this.eventData,
  });

  factory AddEventCattleActivityMassResponse.fromJson(Map<String, dynamic> json) {
    return AddEventCattleActivityMassResponse(
      message: json['message'],
      eventData: json['eventData'] != null
          ? MassEventData.fromJson(json['eventData'])
          : null,
    );
  }
}

class MassEventData {
  final int? id;
  final String? eventType;
  final String? notes;
  final String? medicine;
  final String? dosage;
  final String? date;

  MassEventData({
    this.id,
    this.eventType,
    this.notes,
    this.medicine,
    this.dosage,
    this.date,
  });

  factory MassEventData.fromJson(Map<String, dynamic> json) {
    return MassEventData(
      id: json['id'],
      eventType: json['eventType'],
      notes: json['notes'],
      medicine: json['medicine'],
      dosage: json['dosage'],
      date: json['date'],
    );
  }
}
