// class AddVeterinairsResponse {
//   final int? id;
//   final String name;
//   final String email;
//   final String phone;
//   final String specialty;
//   final String nationalID;
//   final String? imagePath;
//   final int? age;
//   final int? experience;
//   final double? salary;
//
//   AddVeterinairsResponse({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.specialty,
//     required this.nationalID,
//     this.imagePath,
//     this.age,
//     this.experience,
//     this.salary,
//   });
//
//   factory AddVeterinairsResponse.fromJson(Map<String, dynamic> json) {
//     return AddVeterinairsResponse(
//       id: json['id'] != null ? json['id'] as int : null,
//       name: json['name'] ?? "",
//       email: json['email'] ?? "",
//       phone: json['phone'] ?? "",
//       specialty: json['specialty'] ?? "",
//       nationalID: json['nationalID'] ?? "",
//       imagePath: json['imagePath'],
//       age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
//       experience: json['experience'] != null ? int.tryParse(json['experience'].toString()) : null,
//       salary: json['salary'] != null ? double.tryParse(json['salary'].toString()) : null,
//     );
//   }
// }


class AddVeterinairsResponse {
  final String message;
  final int veterinarId;
  final String code;
  final String createdAt;
  final String imageUrl;

  AddVeterinairsResponse({
    required this.message,
    required this.veterinarId,
    required this.code,
    required this.createdAt,
    required this.imageUrl,
  });

  factory AddVeterinairsResponse.fromJson(Map<String, dynamic> json) {
    return AddVeterinairsResponse(
      message: json['message'] ?? '',
      veterinarId: json['veterinarId'] ?? 0,
      code: json['code'] ?? '',
      createdAt: json['createdAt'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
