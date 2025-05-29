// class AddWorkerResponse {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String specialty;
//   final String nationalID;
//   final String? imagePath;
//
//   AddWorkerResponse({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.specialty,
//     required this.nationalID,
//     this.imagePath,
//   });
//
//   factory AddWorkerResponse.fromJson(Map<String, dynamic> json) {
//     return AddWorkerResponse(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       specialty: json['specialty'],
//       nationalID: json['nationalID'],
//       imagePath: json['imagePath'],
//     );
//   }
// }
class AddWorkerResponse {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String specialty;
  final String nationalID;
  final String? imagePath;
  final int? age;
  final int? experience;
  final double? salary;

  AddWorkerResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.nationalID,
    this.imagePath,
    this.age,
    this.experience,
    this.salary,
  });

  factory AddWorkerResponse.fromJson(Map<String, dynamic> json) {
    return AddWorkerResponse(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      specialty: json['specialty'] ?? "",
      nationalID: json['nationalID'] ?? "",
      imagePath: json['imagePath'],
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      experience: json['experience'] != null ? int.tryParse(json['experience'].toString()) : null,
      salary: json['salary'] != null ? double.tryParse(json['salary'].toString()) : null,
    );
  }
}
