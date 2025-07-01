class CattleModel {
  final int cattleID;
  final String type;
  final int weight;
  final String gender;
  final int age;

  CattleModel({
    required this.cattleID,
    required this.type,
    required this.weight,
    required this.gender,
    required this.age,
  });

  factory CattleModel.fromJson(Map<String, dynamic> json) {
    return CattleModel(
      cattleID: json['cattleID'],
      type: json['type'],
      weight: json['weight'],
      gender: json['gender'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cattleID': cattleID,
      'type': type,
      'weight': weight,
      'gender': gender,
      'age': age,
    };
  }
}
