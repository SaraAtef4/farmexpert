class MilkProductionRecord {
  final int id;
  final String tagNumber;
  final String countNumber;
  final double am;
  final double noon;
  final double pm;
  final double total;
  final String notes;
  final DateTime date;

  MilkProductionRecord({
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

  factory MilkProductionRecord.fromJson(Map<String, dynamic> json) {
    return MilkProductionRecord(
      id: json['id'],
      tagNumber: json['tagNumber'],
      countNumber: json['countNumber'],
      am: (json['am'] ?? 0).toDouble(),
      noon: (json['noon'] ?? 0).toDouble(),
      pm: (json['pm'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}
