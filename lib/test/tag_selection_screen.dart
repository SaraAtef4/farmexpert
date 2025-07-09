// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:farmxpert/core/theme/colors.dart';
//
// import '../data/providers/cattle_provider.dart';
//
// class TagSelectionScreen extends StatefulWidget {
//   final bool femalesOnly;
//
//   const TagSelectionScreen({Key? key, this.femalesOnly = false}) : super(key: key);
//
//   @override
//   _TagSelectionScreenState createState() => _TagSelectionScreenState();
// }
//
// class _TagSelectionScreenState extends State<TagSelectionScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<String> allTags = [];
//   List<String> filteredTags = [];
//   bool isSearchFocused = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     if (allTags.isEmpty) { // تأكدي من عدم تحميل البيانات أكثر من مرة
//       if (widget.femalesOnly) {
//         loadFemaleTags();
//       } else {
//         loadAllTags();
//       }
//     }
//   }
//
//
//   void loadAllTags() {
//     final cattleProvider = Provider.of<CattleProvider>(context, listen: false);
//     setState(() {
//       allTags = cattleProvider.getAllTags();
//       if (allTags.isEmpty) {
//         allTags = ["001", "002", "003", "004", "005"];
//       }
//       filteredTags = allTags;
//     });
//   }
//
//   void loadFemaleTags() {
//     final cattleProvider = Provider.of<CattleProvider>(context, listen: false);
//     setState(() {
//       allTags = cattleProvider.getFemaleTagsOnly();
//       print("Loaded female tags: $allTags"); // تحقق من القيم في debug console
//       if (allTags.isEmpty) {
//         allTags = ["001", "002", "003"];
//       }
//       filteredTags = List.from(allTags);
//     });
//   }
//
//   void filterTags(String query) {
//     setState(() {
//       filteredTags = allTags.where((tag) => tag.toLowerCase().contains(query.toLowerCase())).toList();
//     });
//   }
//
//   void selectTag(String tag) {
//     Navigator.pop(context, tag);
//   }
//
//   Widget _buildTagCard(String tag) {
//     final cattleProvider = Provider.of<CattleProvider>(context, listen: false);
//     String cattleType = "";
//     String cattleGender = "";
//
//     // البحث عن معلومات الحيوان المرتبط بهذا التاج
//     cattleProvider.cattleData.forEach((category, cattleList) {
//       for (var cattle in cattleList) {
//         if (cattle.containsKey("id") && cattle["id"] == tag) {
//           cattleType = category;
//           cattleGender = cattle.containsKey("gender") ? cattle["gender"].toString() : "";
//           break;
//         }
//       }
//     });
//
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       margin: EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () => selectTag(tag),
//           splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
//           highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       tag,
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Tag Number: $tag",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       if (cattleType.isNotEmpty) ...[
//                         SizedBox(height: 4),
//                         Text(
//                           "Type: $cattleType",
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                       if (cattleGender.isNotEmpty) ...[
//                         SizedBox(height: 2),
//                         Text(
//                           "Gender: $cattleGender",
//                           style: TextStyle(
//                             color: cattleGender.toLowerCase() == "female"
//                                 ? Colors.pink.shade700
//                                 : Colors.blue.shade700,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                       if (cattleType.isEmpty && cattleGender.isEmpty) ...[
//                         SizedBox(height: 4),
//                         Text(
//                           "Tap to select",
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.chevron_right_rounded,
//                   color: Colors.grey[400],
//                   size: 24,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.femalesOnly ? "Select Female Tag" : "Select Tag Number",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor:  Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(16),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.help_outline),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   backgroundColor: Colors.white,
//                   title: Text("Help"),
//                   content: Text( "Search for tag numbers or select from the list."),
//                   actions: [
//                     TextButton(
//                       child: Text("OK", style: TextStyle(color: AppColors.secondaryColor),),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.grey[50],
//       body: Column(
//         children: [
//           // إضافة شريط معلومات للتوضيح
//
//
//           // Search Bar with improved design
//           Container(
//             width: double.infinity,
//             height: 50,
//             margin: EdgeInsets.fromLTRB(16, widget.femalesOnly ? 8 : 20, 16, 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Focus(
//               onFocusChange: (hasFocus) {
//                 setState(() {
//                   isSearchFocused = hasFocus;
//                 });
//               },
//               child: TextField(
//                 cursorColor:  AppColors.secondaryColor,
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: widget.femalesOnly
//                       ? "Search for female tag"
//                       : "Search for tag number",
//                   hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w300, fontSize: 16),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: isSearchFocused
//                         ? ( Theme.of(context).primaryColor)
//                         : Colors.grey[400],
//                   ),
//                   suffixIcon: searchController.text.isNotEmpty
//                       ? IconButton(
//                     icon: Icon(Icons.clear, color: Colors.grey[500]),
//                     onPressed: () {
//                       searchController.clear();
//                       filterTags("");
//                     },
//                   )
//                       : null,
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 ),
//                 onChanged: filterTags,
//                 keyboardType: TextInputType.text,
//               ),
//             ),
//           ),
//
//           // Empty state - show when no tags match search
//           if (filteredTags.isEmpty)
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.search_off_rounded,
//                       size: 80,
//                       color: Colors.grey[300],
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "No matching results",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Try searching differently",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: () {
//                         searchController.clear();
//                         if (widget.femalesOnly) {
//                           loadFemaleTags();
//                         } else {
//                           loadAllTags();
//                         }
//                       },
//                       child: Text(
//                         widget.femalesOnly ? "View All Female Tags" : "View All Tags",
//                         style: TextStyle(
//                             color:  AppColors.secondaryColor
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           // Results counter
//           if (filteredTags.isNotEmpty)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     searchController.text.isEmpty
//                         ? (widget.femalesOnly ? "All Female Tags" : "All Tags")
//                         : "Search Results",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   Text(
//                     "${filteredTags.length} items",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           // Tag list with improved design
//           if (filteredTags.isNotEmpty)
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
//                 itemCount: filteredTags.length,
//                 itemBuilder: (context, index) {
//                   return _buildTagCard(filteredTags[index]);
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }


import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:flutter/material.dart';
import 'package:farmxpert/core/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TagSelectionScreen extends StatefulWidget {
  final bool femalesOnly;

  const TagSelectionScreen({Key? key, this.femalesOnly = false}) : super(key: key);

  @override
  _TagSelectionScreenState createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> allTags = [];
  List<String> filteredTags = [];
  bool isSearchFocused = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.femalesOnly) {
      loadFemaleTagsFromApi();
    } else {
      loadDummyTags(); // مؤقتًا، لو مش female
    }
  }

  void loadDummyTags() {
    allTags = ["001", "002", "003"];
    filteredTags = List.from(allTags);
  }

  Future<void> loadFemaleTagsFromApi() async {
    setState(() => isLoading = true);
    final token = await getUserToken(); // استبدلها بطريقتك لجلب التوكن
    final cows = await ApiManager.getFemaleCows(token ?? "");
    if (cows != null) {
      setState(() {
        allTags = cows.map((e) => e.cattleID.toString()).toList();
        filteredTags = List.from(allTags);
        isLoading = false;
      });
    } else {
      setState(() {
        allTags = [];
        filteredTags = [];
        isLoading = false;
      });
    }
  }

  void filterTags(String query) {
    setState(() {
      filteredTags = allTags
          .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void selectTag(String tag) {
    Navigator.pop(context, tag);
  }

  Widget _buildTagCard(String tag) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => selectTag(tag),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tag Number: $tag",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text("Type: Cow",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 14)),
                      Text("Gender: Female",
                          style: TextStyle(
                            color: Colors.pink.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.femalesOnly ? "Select Female Tag" : "Select Tag"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search bar
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(16, 16, 16, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Focus(
              onFocusChange: (hasFocus) =>
                  setState(() => isSearchFocused = hasFocus),
              child: TextField(
                controller: searchController,
                cursorColor: AppColors.secondaryColor,
                style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "Search for tag number",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w300),
                  prefixIcon: Icon(Icons.search,
                      color: isSearchFocused
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400]),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear,
                        color: Colors.grey[500]),
                    onPressed: () {
                      searchController.clear();
                      filterTags("");
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: filterTags,
              ),
            ),
          ),
          // Tag list or no result
          if (filteredTags.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No tags found",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filteredTags.length,
                itemBuilder: (context, index) =>
                    _buildTagCard(filteredTags[index]),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
