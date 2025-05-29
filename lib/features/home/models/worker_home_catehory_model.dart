import 'package:flutter/material.dart';

class WorkerHomeCategoryModel {
  String id;
  String name;
  String image;
  Color color;

  WorkerHomeCategoryModel(
      {
        required this.id,
        required this.name,
        required this.image,
        required this.color
      });

  static List<WorkerHomeCategoryModel> getCategories(){
    return[
      WorkerHomeCategoryModel(
        id: "",
        name: "Cattle Activity",
        image: "assets/images/cattle_activity.png",
        color: Color(0xffFAFAFA),
      ),
      WorkerHomeCategoryModel(
        id: "",
        name: "Milk Production",
        image: "assets/images/milk_home.png",
        color: Color(0xffFCFFE2),
      ),
      WorkerHomeCategoryModel(
        id: "",
        name: "Reminders",
        image: "assets/images/clock.png",
        color: Color(0xffFAFAFA),
      ),
      WorkerHomeCategoryModel(
        id: "",
        name: "Clinic",
        image: "assets/images/clinic 1.png",
        color: Color(0xffE9FFEA),
      ),
    ];
  }
}
