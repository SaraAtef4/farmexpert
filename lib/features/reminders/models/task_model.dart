
class TaskModel {
  String id;
  String title;
  String subtitle;
  int date;
  String time;
  bool isDone; // ✅ هذا المتغير يتحكم في تفعيل الإشعارات
  List<int> repeatDays;

  TaskModel({
    this.id = "",
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    this.isDone = true, // ✅ تعيينه إلى true عند إنشاء المهمة
    this.repeatDays = const [],
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
    title: json['title'],
    subtitle: json['subtitle'],
    date: json['date'],
    time: json['time'],
    id: json['id'],
    isDone: json['isDone'] ?? true, // ✅ التأكد من أنه true عند استرجاع البيانات
    repeatDays: List<int>.from(json['repeatDays'] ?? []),
  );

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "date": date,
      "time": time,
      "id": id,
      "isDone": isDone, // ✅ حفظ حالة التفعيل في Firestore
      "repeatDays": repeatDays,
    };
  }
}

