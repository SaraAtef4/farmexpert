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
  String? imageUrl;

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
    this.imageUrl,
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
    imageUrl = json['imageUrl'] ?? json['imagePath'];
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
      'imageUrl': imageUrl,
    };
  }

  // رابط الصورة الكامل
  String? get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    return 'http://farmxpertapi.runasp.net$imageUrl';
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
