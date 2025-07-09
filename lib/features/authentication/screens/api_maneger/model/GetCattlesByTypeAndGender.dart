class CattleByTypeAndGender {
  final int cattleID;
  final String type;
  final String gender;
  final int weight;
  final int age;

  CattleByTypeAndGender({
    required this.cattleID,
    required this.type,
    required this.gender,
    required this.weight,
    required this.age,
  });

  factory CattleByTypeAndGender.fromJson(Map<String, dynamic> json) {
    return CattleByTypeAndGender(
      cattleID: json['cattleID'],
      type: json['type'],
      gender: json['gender'],
      weight: json['weight'],
      age: json['age'],
    );
  }
}
