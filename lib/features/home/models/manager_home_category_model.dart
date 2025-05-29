import 'package:flutter/material.dart';

class ManagerHomeCategoryModel {
  String id;
  String name;
  String image;
  Color color;

  ManagerHomeCategoryModel(
      {
        required this.id,
        required this.name,
        required this.image,
        required this.color
      });

  static List<ManagerHomeCategoryModel> getCategories(){
    return[
      ManagerHomeCategoryModel(
        id: "",
        name: "Cattle Activity",
        image: "assets/images/cattle_activity.png",
        color: Color(0xffFAFAFA),
      ),
      ManagerHomeCategoryModel(
        id: "",
        name: "Milk Production",
        image: "assets/images/milk_home.png",
        color: Color(0xffFCFFE2),
      ),
      ManagerHomeCategoryModel(
        id: "",
        name: "Staff",
        image: "assets/images/human 1.png",
        color: Color(0xffFCFFE2),
      ),
      ManagerHomeCategoryModel(
        id: "",
        name: "Reminders",
        image: "assets/images/clock.png",
        color: Color(0xffFAFAFA),
      ),
      ManagerHomeCategoryModel(
        id: "",
        name: "Clinic",
        image: "assets/images/clinic 1.png",
        color: Color(0xffE9FFEA),
      ),
    ];
  }
}
