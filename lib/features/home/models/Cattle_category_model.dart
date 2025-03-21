import 'package:flutter/material.dart';

class CattleCategoryModel {
  String id;
  String name;
  String image;
  Color color;
  String title;
  String description;

  CattleCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.color,
    required this.title,
    required this.description,
  });

  static List<CattleCategoryModel> getCategories() {
    return [
      CattleCategoryModel(
        id: "1",
        name: "Cows",
        image: "assets/images/cows_category.png",
        color: const Color(0xffE9FFEA),
        title: "Cows",
        description: "Adult female cattle for dairy and meat production.",
      ),
      CattleCategoryModel(
        id: "2",
        name: "Calves",
        image: "assets/images/calves_category.png",
        color: const Color(0xffFCFFE2),
        title: "Calves",
        description: "Young cattle that require special care and feeding.",
      ),
      CattleCategoryModel(
        id: "3",
        name: "Heifers",
        image: "assets/images/haifers_category.png",
        color: const Color(0xffFAFAFA),
        title: "Heifers",
        description: "Young female cows that have not given birth yet.",
      ),
      CattleCategoryModel(
        id: "4",
        name: "Weaners",
        image: "assets/images/weaners_category.png",
        color: const Color(0xffFAFAFA),
        title: "Weaners",
        description: "Young cattle that have been weaned off milk.",
      ),
      CattleCategoryModel(
        id: "5",
        name: "Sheep",
        image: "assets/images/sheep_category.png",
        color: const Color(0xffE9FFEA),
        title: "Sheep",
        description: "Domesticated ruminants raised for wool, meat, and milk.",
      ),
      CattleCategoryModel(
        id: "6",
        name: "Bulls",
        image: "assets/images/bull_category.png",
        color: const Color(0xffFCFFE2),
        title: "Bulls",
        description: "Adult male cattle used for breeding and meat production.",
      ),
    ];
  }
}
