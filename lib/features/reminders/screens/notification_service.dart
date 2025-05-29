import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String taskName,
    required DateTime scheduledTime,
  }) async {
    await _notificationsPlugin
        .cancel(id); // 🛑 إلغاء الإشعار القديم قبل جدولة الجديد

    await _notificationsPlugin.zonedSchedule(
      id,
      taskName,
      "📅 الموعد: ${DateFormat.jm().format(scheduledTime)}",
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'تذكيرات المهام',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print(
        "✅ تم جدولة إشعار: $taskName في ${DateFormat.jm().format(scheduledTime)}");
  }

  static Future<void> showInstantNotification({
    required int id,
    required String taskName,
    required DateTime scheduledTime,
  }) async {
    await _notificationsPlugin
        .cancel(id); // 🛑 إلغاء الإشعار القديم قبل إظهار الجديد

    await _notificationsPlugin.show(
      id,
      taskName,
      "📅 الموعد: ${DateFormat.jm().format(scheduledTime)}",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'تذكيرات فورية',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    print("🔔 إشعار فوري: $taskName");
  }
}
