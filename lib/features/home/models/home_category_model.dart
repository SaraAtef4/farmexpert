import 'package:flutter/material.dart';

class HomeCategoryModel {
  String id;
  String name;
  String image;
  Color color;

  HomeCategoryModel(
      {
        required this.id,
        required this.name,
        required this.image,
        required this.color
      });

  static List<HomeCategoryModel> getCategories(){
    return[
      HomeCategoryModel(
        id: "",
        name: "Cattle Activity",
        image: "assets/images/cattle_activity.png",
        color: Color(0xffFAFAFA),
      ),
      HomeCategoryModel(
        id: "",
        name: "Milk Production",
        image: "assets/images/milk_home.png",
        color: Color(0xffFCFFE2),
      ),
      HomeCategoryModel(
        id: "",
        name: "Workers",
        image: "assets/images/human 1.png",
        color: Color(0xffFCFFE2),
      ),
      HomeCategoryModel(
        id: "",
        name: "Reminders",
        image: "assets/images/clock.png",
        color: Color(0xffFAFAFA),
      ),
      HomeCategoryModel(
        id: "",
        name: "Clinic",
        image: "assets/images/clinic 1.png",
        color: Color(0xffE9FFEA),
      ),
    ];
  }
}
