class AddMilkProductionMultipleResponse {
  final String message;
  final BulkMilkRecord milk;

  AddMilkProductionMultipleResponse({
    required this.message,
    required this.milk,
  });

  factory AddMilkProductionMultipleResponse.fromJson(Map<String, dynamic> json) {
    return AddMilkProductionMultipleResponse(
      message: json['message'],
      milk: BulkMilkRecord.fromJson(json['milk']),
    );
  }
}

class BulkMilkRecord {
  final int id;
  final String tagNumber;
  final String countNumber;
  final double am;
  final double noon;
  final double pm;
  final double total;
  final String notes;
  final DateTime date;

  BulkMilkRecord({
    required this.id,
    required this.tagNumber,
    required this.countNumber,
    required this.am,
    required this.noon,
    required this.pm,
    required this.total,
    required this.notes,
    required this.date,
  });

  factory BulkMilkRecord.fromJson(Map<String, dynamic> json) {
    return BulkMilkRecord(
      id: json['id'],
      tagNumber: json['tagNumber'],
      countNumber: json['countNumber'],
      am: (json['am'] as num).toDouble(),
      noon: (json['noon'] as num).toDouble(),
      pm: (json['pm'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
  }
}
