import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmxpert/features/reminders/models/task_model.dart';
import 'package:farmxpert/features/reminders/screens/background_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseFunctions {
  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<void> addTask(TaskModel task) async {
    var collection = getTasksCollection();
    var docRef = collection.doc();
    task.id = docRef.id;
    task.isDone = true; // ✅ جعلها مفعّلة عند الإضافة

    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date);
    task.date = DateUtils.dateOnly(selectedDate).millisecondsSinceEpoch;

    await docRef.set(task); // ✅ حفظ المهمة في Firestore

    DateTime parsedTime = DateFormat.jm().parse(task.time);
    int hour = parsedTime.hour;
    int minute = parsedTime.minute;

    DateTime fullDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    DateTime reminderTime = fullDateTime.subtract(Duration(minutes: 5));

    // ✅ إرسال الإشعار فقط إذا كانت المهمة مفعّلة
    // if (task.isDone) {
    //   await NotificationService.showInstantNotification(
    //     id: task.id.hashCode,
    //     taskName: task.title,
    //     scheduledTime: fullDateTime,
    //   );
    //
    //   await BackgroundService.scheduleTask(
    //     task.id.hashCode,
    //     task.title,
    //     reminderTime,
    //   );
    //
    //   for (int day in task.repeatDays) {
    //     await BackgroundService.scheduleRepeatingTask(
    //       task.id.hashCode + day,
    //       task.title,
    //       reminderTime,
    //       day,
    //     );
    //   }
    // }
    if (task.isDone) {
      await BackgroundService.scheduleTask(
        task.id.hashCode,
        task.title,
        reminderTime,
      );

      for (int day in task.repeatDays) {
        await BackgroundService.scheduleRepeatingTask(
          task.id.hashCode + day,
          task.title,
          reminderTime,
          day,
        );
      }
    }
  }

  // static Future<void> addTask(TaskModel task) async {
  //   var collection = getTasksCollection();
  //   var docRef = collection.doc();
  //   task.id = docRef.id;
  //   task.isDone = true; // ✅ جعلها مفعّلة عند الإضافة
  //
  //   DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date);
  //   task.date = DateUtils.dateOnly(selectedDate).millisecondsSinceEpoch;
  //
  //   await docRef.set(task); // ✅ حفظ المهمة في Firestore
  //
  //   DateTime parsedTime = DateFormat.jm().parse(task.time);
  //   int hour = parsedTime.hour;
  //   int minute = parsedTime.minute;
  //
  //   DateTime fullDateTime = DateTime(
  //     selectedDate.year,
  //     selectedDate.month,
  //     selectedDate.day,
  //     hour,
  //     minute,
  //   );
  //
  //   DateTime reminderTime = fullDateTime.subtract(Duration(minutes: 5));
  //
  //   if (task.isDone) {
  //     // ✅ إرسال إشعار قبل 5 دقائق
  //     await BackgroundService.scheduleTask(
  //       task.id.hashCode,
  //       task.title,
  //       reminderTime,
  //     );
  //
  //     // ✅ إرسال إشعار في الوقت المحدد
  //     await BackgroundService.scheduleTask(
  //       task.id.hashCode + 1, // ✅ يجب تغيير الـ id ليكون مختلفًا عن الإشعار الأول
  //       task.title,
  //       fullDateTime,
  //     );
  //
  //     for (int day in task.repeatDays) {
  //       // ✅ إرسال إشعار متكرر قبل 5 دقائق
  //       await BackgroundService.scheduleRepeatingTask(
  //         task.id.hashCode + day,
  //         task.title,
  //         reminderTime,
  //         day,
  //       );
  //
  //       // ✅ إرسال إشعار متكرر في الوقت المحدد
  //       await BackgroundService.scheduleRepeatingTask(
  //         task.id.hashCode + day + 1,
  //         task.title,
  //         fullDateTime,
  //         day,
  //       );
  //     }
  //   }
  // }

  static Stream<QuerySnapshot<TaskModel>> getTasks(DateTime date) {
    var collection = getTasksCollection();
    return collection
        .where("date",
            isGreaterThanOrEqualTo:
                DateUtils.dateOnly(date).millisecondsSinceEpoch)
        .where("date",
            isLessThan: DateUtils.dateOnly(date.add(Duration(days: 1)))
                .millisecondsSinceEpoch)
        .snapshots();
  }

  static Future<void> deleteTask(String id) {
    return getTasksCollection().doc(id).delete();
  }

  static Future<void> updateTask(TaskModel taskModel) {
    return getTasksCollection().doc(taskModel.id).update(taskModel.toJson());
  }
}
