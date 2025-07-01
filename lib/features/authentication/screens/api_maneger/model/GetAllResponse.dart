// class GetAllResponse {
//   int? id;
//   String? name;
//   String? nationalID;
//   int? age;
//   String? experience;
//   String? specialty;
//   String? phone;
//   int? salary;
//   String? code;
//   String? createdAt;
//   String? email;
//   String? imagePath;
//
//   GetAllResponse(
//       {this.id,
//         this.name,
//         this.nationalID,
//         this.age,
//         this.experience,
//         this.specialty,
//         this.phone,
//         this.salary,
//         this.code,
//         this.createdAt,
//         this.email,
//         this.imagePath});
//
//   GetAllResponse.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     nationalID = json['nationalID'];
//     age = json['age'];
//     experience = json['experience'];
//     specialty = json['specialty'];
//     phone = json['phone'];
//     salary = json['salary'];
//     code = json['code'];
//     createdAt = json['createdAt'];
//     email = json['email'];
//     imagePath = json['imagePath'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['nationalID'] = this.nationalID;
//     data['age'] = this.age;
//     data['experience'] = this.experience;
//     data['specialty'] = this.specialty;
//     data['phone'] = this.phone;
//     data['salary'] = this.salary;
//     data['code'] = this.code;
//     data['createdAt'] = this.createdAt;
//     data['email'] = this.email;
//     data['imagePath'] = this.imagePath;
//     return data;
//   }
// }

class GetAllResponse {
  int? id;
  String? name;
  String? nationalID;
  int? age;
  String? experience;
  String? specialty;
  String? phone;
  double? salary;
  String? code;
  String? createdAt;
  String? email;
  String? imagePath;

  GetAllResponse({
    this.id,
    this.name,
    this.nationalID,
    this.age,
    this.experience,
    this.specialty,
    this.phone,
    this.salary,
    this.code,
    this.createdAt,
    this.email,
    this.imagePath,
  });

  // تحويل JSON إلى كائن
  GetAllResponse.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = json['name'];
    nationalID = json['nationalID'];
    age = _parseInt(json['age']);
    experience = json['experience'];
    specialty = json['specialty'];
    phone = json['phone'];
    salary = _parseDouble(json['salary']);
    code = json['code'];
    createdAt = json['createdAt'];
    email = json['email'];
    imagePath = json['imagePath'];
  }

  // تحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nationalID': nationalID,
      'age': age,
      'experience': experience,
      'specialty': specialty,
      'phone': phone,
      'salary': salary,
      'code': code,
      'createdAt': createdAt,
      'email': email,
      'imagePath': imagePath,
    };
  }

  // تحويل String إلى int مع التعامل مع الحالات غير المتوافقة
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
