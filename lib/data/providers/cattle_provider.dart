import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CattleProvider with ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> _cattleData = {
    "Sheep": [],
    "Cows": [],
    "Heifers": [],
    "Bulls": [],
    "Weaners": [],
    "Calves": [],
  };

  Map<String, List<Map<String, dynamic>>> get cattleData => _cattleData;

  set cattleData(Map<String, List<Map<String, dynamic>>> value) {
    _cattleData = value;
    notifyListeners();
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cattleDataJson = prefs.getString('cattleData');

      if (cattleDataJson != null) {
        _cattleData = Map<String, List<Map<String, dynamic>>>.from(
          jsonDecode(cattleDataJson).map((key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value))),
        );
        notifyListeners();
        print("Loaded Data: $_cattleData"); // طباعة البيانات المحملة
      } else {
        print("No data found in SharedPreferences."); // إذا لم توجد بيانات
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cattleDataJson = jsonEncode(_cattleData);
      prefs.setString('cattleData', cattleDataJson);
      print("Data saved successfully: $_cattleData"); // طباعة البيانات المحفوظة
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  void addCattle(String category, Map<String, dynamic> cattle) {
    _cattleData[category]?.add(cattle);
    notifyListeners();
    saveData();
  }

  void updateCattle(String category, String id, Map<String, dynamic> updatedCattle) {
    final index = _cattleData[category]?.indexWhere((cattle) => cattle["id"] == id);
    if (index != -1 && index != null) {
      _cattleData[category]?[index] = updatedCattle;
      notifyListeners();
      saveData();
    }
  }

  void deleteCattle(String category, String id) {
    _cattleData[category]?.removeWhere((cattle) => cattle["id"] == id);
    notifyListeners();
    saveData();
  }



  List<String> getAllTags() {
    List<String> allTags = [];

    _cattleData.forEach((category, cattleList) {
      for (var cattle in cattleList) {
        if (cattle.containsKey("id") && cattle["id"] != null) {
          String tag = cattle["id"].toString();
          if (!allTags.contains(tag)) {
            allTags.add(tag);
          }
        }
      }
    });

    allTags.sort();
    return allTags;
  }

  List<Map<String, dynamic>> getFemaleCattle() {
    List<Map<String, dynamic>> femaleCattle = [];

    final femaleOnlyCategories = ["Cows", "Heifers"];

    for (var category in femaleOnlyCategories) {
      if (_cattleData.containsKey(category)) {
        femaleCattle.addAll(_cattleData[category] ?? []);
      }
    }

    final mixedCategories = ["Calves", "Weaners", "Sheep"];

    for (var category in mixedCategories) {
      if (_cattleData.containsKey(category)) {
        for (var animal in _cattleData[category] ?? []) {
          if (animal.containsKey("gender") &&
              (animal["gender"].toString().toLowerCase() == "female" ||
                  animal["gender"] == "أنثى")) {
            femaleCattle.add(animal);
          }
        }
      }
    }

    return femaleCattle;
  }

  List<String> getFemaleTagsOnly() {
    return _cattleData.entries
        .expand((entry) => entry.value)
        .where((cattle) => cattle["gender"]?.toString().toLowerCase() == "female")
        .map((cattle) => cattle["id"].toString())
        .toList();
  }

}