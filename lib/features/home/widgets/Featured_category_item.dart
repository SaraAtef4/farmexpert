import 'package:flutter/material.dart';
import '../models/Cattle_category_model.dart';
import '../screens/tabs_category/category_detail_screen.dart';

class FeaturedCategoryItem extends StatelessWidget {
  final CattleCategoryModel category;
  final Size screenSize;
  String IconPath;

   FeaturedCategoryItem({
    Key? key,
    required this.category,
    required this.screenSize,
    required this.IconPath
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width * 0.9,
      height: screenSize.width * 0.33,
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.green.shade300,
                        Colors.green.shade700,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     ImageIcon(AssetImage(IconPath)),
                      SizedBox(height: 8),
                      Text(
                        category.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        category.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}