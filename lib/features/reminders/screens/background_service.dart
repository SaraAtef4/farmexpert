import 'package:farmxpert/features/reminders/screens/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  // ✅ جدولة إشعار لمرة واحدة
  static Future<void> scheduleTask(
      int id, String taskName, DateTime scheduledTime) async {
    await Workmanager().cancelByTag(
        "task_reminder_$id"); // 🛑 إلغاء المهمة القديمة قبل جدولة الجديدة

    await Workmanager().registerOneOffTask(
      id.toString(),
      "task_reminder",
      tag: "task_reminder_$id",
      existingWorkPolicy:
          ExistingWorkPolicy.replace, // 🔄 استبدال المهمة القديمة
      initialDelay: scheduledTime.difference(DateTime.now()),
      inputData: {
        "id": id,
        "taskName": taskName,
        "scheduledTime": scheduledTime.millisecondsSinceEpoch,
      },
    );

    print("✅ تم جدولة المهمة لمرة واحدة: $taskName في $scheduledTime");
  }

  static Future<void> scheduleRepeatingTask(
      int id, String taskName, DateTime scheduledTime, int dayOfWeek) async {
    await Workmanager()
        .cancelByTag("repeating_task_$id"); // 🛑 إلغاء أي مهام متكررة سابقة

    // ✅ حساب عدد الأيام حتى يوم التكرار المطلوب
    int today = DateTime.now().weekday; // اليوم الحالي
    int daysUntilNext = (dayOfWeek - today) % 7;
    if (daysUntilNext < 0) daysUntilNext += 7; // التأكد من القيمة الموجبة

    DateTime firstExecution = scheduledTime.add(Duration(days: daysUntilNext));

    await Workmanager().registerPeriodicTask(
      id.toString(),
      "repeating_task_reminder",
      tag: "repeating_task_$id",
      frequency: Duration(days: 1), // ⏳ تكرار يومي
      initialDelay: firstExecution
          .difference(DateTime.now()), // ✅ تأخير التنفيذ ليبدأ في اليوم الصحيح
      inputData: {
        "id": id,
        "taskName": taskName,
        "scheduledTime": firstExecution.millisecondsSinceEpoch,
      },
      existingWorkPolicy:
          ExistingWorkPolicy.replace, // 🔄 استبدال المهمة القديمة
    );

    print(
        "✅ تم جدولة المهمة المتكررة: $taskName لأول مرة في $firstExecution (يوم الأسبوع: $dayOfWeek)");
  }

  static Future<void> cancelTask(int id) async {
    await Workmanager().cancelByTag("task_reminder_$id");
    await Workmanager().cancelByTag("repeating_task_$id");
    print("🚫 تم إلغاء الإشعارات للمهمة ذات المعرف: $id");
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    int id = inputData?['id'] ?? 999;
    String taskName = inputData?['taskName'] ?? "⏰ تذكير!";
    DateTime scheduledTime = DateTime.fromMillisecondsSinceEpoch(
        inputData?['scheduledTime'] ?? DateTime.now().millisecondsSinceEpoch);

    // ✅ إضافة طباعة للتأكد أن WorkManager يعمل
    print("📢 تم تنفيذ المهمة المجدولة: $taskName في $scheduledTime");

    await NotificationService.showInstantNotification(
      id: id,
      taskName: taskName,
      scheduledTime: scheduledTime,
    );

    return Future.value(true);
  });
}
