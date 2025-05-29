import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/milk_entry_model.dart';

class LocalStorageService {
  static const String _storageKey = 'milk_entries';

  /// حفظ البيانات في Shared Preferences
  static Future<void> saveEntries(List<MilkEntryModel> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
    json.encode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  /// تحميل البيانات من Shared Preferences
  static Future<List<MilkEntryModel>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_storageKey);

    if (encodedData != null) {
      final List<dynamic> decoded = json.decode(encodedData);
      return decoded.map((e) => MilkEntryModel.fromJson(e)).toList();
    }
    return [];
  }

  /// مسح جميع البيانات المخزنة
  static Future<void> clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
