//
// class MilkEntryModel {
//   String date;
//   String? tagNumber;
//   double morningMilk;
//   double noonMilk;
//   double eveningMilk;
//   double totalMilk;
//   String? notes;
//   int? cowsCount;
//
//   MilkEntryModel({
//     required this.date,
//     required this.tagNumber,
//     required this.morningMilk,
//     required this.noonMilk,
//     required this.eveningMilk,
//     required this.totalMilk,
//     required this.notes,
//     this.cowsCount,
//   });
//
//   /// تحويل لJSON لتخزينه في SharedPreferences
//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'tagNumber': tagNumber,
//       'morningMilk': morningMilk,
//       'noonMilk': noonMilk,
//       'eveningMilk': eveningMilk,
//       'totalMilk': totalMilk,
//       'notes': notes,
//       'cowsCount': cowsCount,
//     };
//   }
//
//   factory MilkEntryModel.fromJson(Map<String, dynamic> json) {
//     return MilkEntryModel(
//       date: json['date'],
//       tagNumber: json['tagNumber'],
//       morningMilk: (json['morningMilk'] as num).toDouble(),
//       noonMilk: (json['noonMilk'] as num).toDouble(),
//       eveningMilk: (json['eveningMilk'] as num).toDouble(),
//       totalMilk: (json['totalMilk'] as num).toDouble(),
//       notes: json['notes'],
//       cowsCount: json['cowsCount'],
//     );
//   }
//
//
// }


class MilkEntryModel {
  final int id;
  final String date;
  final String? tagNumber;
  final String countNumber;
  final double am;
  final double noon;
  final double pm;
  final double total;
  final String notes;

  MilkEntryModel({
    required this.id,
    required this.date,
    required this.tagNumber,
    required this.countNumber,
    required this.am,
    required this.noon,
    required this.pm,
    required this.total,
    required this.notes,
  });

  factory MilkEntryModel.fromJson(Map<String, dynamic> json) {
    return MilkEntryModel(
      id: json['id'],
      date: json['date'],
      tagNumber: json['tagNumber'] == "multiple" ? null : json['tagNumber'],
      countNumber: json['countNumber'],
      am: (json['am'] as num).toDouble(),
      noon: (json['noon'] as num).toDouble(),
      pm: (json['pm'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'tagNumber': tagNumber,
      'countNumber': countNumber,
      'am': am,
      'noon': noon,
      'pm': pm,
      'total': total,
      'notes': notes,
    };
  }
}
