import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:flutter/material.dart';

class CattleCategoryModel {
  final String type; // بدل id
  final String imagePath;
  int count;
  final Color color;

  CattleCategoryModel({
    required this.type,
    required this.imagePath,
    this.count = 0,
    required this.color,
  });

  // ممكن نستخدم دي بشكل مؤقت أو نربطها بـ API بعدين
  static Future<List<CattleCategoryModel>> getCategoriesWithCount(String token) async {
    final List<CattleCategoryModel> categories = [
      CattleCategoryModel(
        type: "Sheep",
        imagePath: "assets/images/sheep.png",
        count: 0, // Placeholder
        color: Colors.indigo[200]!,
      ),
      CattleCategoryModel(
        type: "Cows",
        imagePath: "assets/images/cow.png",
        count: 0,
        color: Colors.deepOrange[400]!,
      ),
      CattleCategoryModel(
        type: "Heifers",
        imagePath: "assets/images/heifers.png",
        count: 0,
        color: Colors.amber[500]!,
      ),
      CattleCategoryModel(
        type: "Bulls",
        imagePath: "assets/images/bull.png",
        count: 0,
        color: Colors.red[700]!,
      ),
      CattleCategoryModel(
        type: "Weaners",
        imagePath: "assets/images/weaners.png",
        count: 0,
        color: Colors.lightGreen[400]!,
      ),
      CattleCategoryModel(
        type: "Calves",
        imagePath: "assets/images/calves.png",
        count: 0,
        color: Colors.pink[200]!,
      ),
    ];

    // نجيب العدد الحقيقي من ال API ونعدله
    for (int i = 0; i < categories.length; i++) {
      final cattleList = await ApiManager.getCattlesByType(categories[i].type, token);
      categories[i] = CattleCategoryModel(
        type: categories[i].type,
        imagePath: categories[i].imagePath,
        count: cattleList.length, // 👈 هنا بنحدث العدد
        color: categories[i].color,
      );
    }

    return categories;
  }
}
