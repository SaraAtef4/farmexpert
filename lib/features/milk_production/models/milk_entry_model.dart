
class MilkEntryModel {
  String date;
  String? tagNumber;
  double morningMilk;
  double noonMilk;
  double eveningMilk;
  double totalMilk;
  String? notes;
  int? cowsCount;

  MilkEntryModel({
    required this.date,
    this.tagNumber,
    required this.morningMilk,
    required this.noonMilk,
    required this.eveningMilk,
    required this.totalMilk,
    this.notes,
    this.cowsCount,
  });

  /// تحويل لJSON لتخزينه في SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'tagNumber': tagNumber,
      'morningMilk': morningMilk,
      'noonMilk': noonMilk,
      'eveningMilk': eveningMilk,
      'totalMilk': totalMilk,
      'notes': notes,
      'cowsCount': cowsCount,
    };
  }

  factory MilkEntryModel.fromJson(Map<String, dynamic> json) {
    return MilkEntryModel(
      date: json['date'],
      tagNumber: json['tagNumber'],
      morningMilk: (json['morningMilk'] as num).toDouble(),
      noonMilk: (json['noonMilk'] as num).toDouble(),
      eveningMilk: (json['eveningMilk'] as num).toDouble(),
      totalMilk: (json['totalMilk'] as num).toDouble(),
      notes: json['notes'],
      cowsCount: json['cowsCount'],
    );
  }


}
