// class UpdateWorkerResponse {
//   String? message;
//   Worker? worker;
//
//   UpdateWorkerResponse({this.message, this.worker});
//
//   UpdateWorkerResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     worker =
//     json['worker'] != null ? new Worker.fromJson(json['worker']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     if (this.worker != null) {
//       data['worker'] = this.worker!.toJson();
//     }
//     return data;
//   }
// }
//
// class Worker {
//   int? id;
//   String? name;
//   String? specialty;
//   Null? salary;
//   String? nationalID;
//   String? phone;
//   Null? experience;
//   Null? imagePath;
//
//   Worker(
//       {this.id,
//         this.name,
//         this.specialty,
//         this.salary,
//         this.nationalID,
//         this.phone,
//         this.experience,
//         this.imagePath});
//
//   Worker.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     specialty = json['specialty'];
//     salary = json['salary'];
//     nationalID = json['nationalID'];
//     phone = json['phone'];
//     experience = json['experience'];
//     imagePath = json['imagePath'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['specialty'] = this.specialty;
//     data['salary'] = this.salary;
//     data['nationalID'] = this.nationalID;
//     data['phone'] = this.phone;
//     data['experience'] = this.experience;
//     data['imagePath'] = this.imagePath;
//     return data;
//   }
// }

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
  final int salary;
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
