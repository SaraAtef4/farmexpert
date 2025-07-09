class UpdateVeterinairResponse {
  final String message;
  final Veterinair veterinair;

  UpdateVeterinairResponse({
    required this.message,
    required this.veterinair,
  });

  factory UpdateVeterinairResponse.fromJson(Map<String, dynamic> json) {
    return UpdateVeterinairResponse(
      message: "Veterinair updated successfully", // ✅ يدويًا
      veterinair: Veterinair.fromJson(json),      // ✅ لأن البيانات كلها جاية مباشرة
    );
  }
}

class Veterinair {
  final int id;
  final String name;
  final String specialty;
  final double salary;
  final String nationalID;
  final String phone;
  final String? experience;
  final String? imagePath;

  Veterinair({
    required this.id,
    required this.name,
    required this.specialty,
    required this.salary,
    required this.nationalID,
    required this.phone,
    this.experience,
    this.imagePath,
  });

  factory Veterinair.fromJson(Map<String, dynamic> json) {
    return Veterinair(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      salary: json['salary'],
      nationalID: json['nationalID'],
      phone: json['phone'],
      experience: json['experience'],
      imagePath: json['imagePath'],
    );
  }
}
