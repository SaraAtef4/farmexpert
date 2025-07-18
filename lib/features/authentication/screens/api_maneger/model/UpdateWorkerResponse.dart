class UpdateWorkerResponse {
  final String message;
  final Worker worker;

  UpdateWorkerResponse({
    required this.message,
    required this.worker,
  });

  factory UpdateWorkerResponse.fromJson(Map<String, dynamic> json) {
    return UpdateWorkerResponse(
      message: json['message'],
      worker: Worker.fromJson(json['worker']),
    );
  }
}

class Worker {
  final int id;
  final String name;
  final String specialty;
  final double salary;
  final String nationalID;
  final String phone;
  final String? experience;
  final String? imagePath;

  Worker({
    required this.id,
    required this.name,
    required this.specialty,
    required this.salary,
    required this.nationalID,
    required this.phone,
    this.experience,
    this.imagePath,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
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
