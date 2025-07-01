// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../data/providers/cattle_provider.dart';
//
// class CattleDetailsScreen extends StatefulWidget {
//   final String category;
//   final Color color;
//
//   const CattleDetailsScreen({
//     super.key,
//     required this.category,
//     required this.color,
//   });
//
//   @override
//   _CattleDetailsScreenState createState() => _CattleDetailsScreenState();
// }
//
// class _CattleDetailsScreenState extends State<CattleDetailsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = "";
//
//   // Filter options
//   List<String> selectedGenders = [];
//   List<String> selectedAges = [];
//
//   // Sorting state
//   bool _isAscending = true;
//   String _currentSortBy = "";
//
//   @override
//   Widget build(BuildContext context) {
//     final cattleProvider = Provider.of<CattleProvider>(context);
//     final cattleList = cattleProvider.cattleData[widget.category] ?? [];
//     final filteredList = _filterCattleList(cattleList);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.category,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: widget.color,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Search by ID...",
//                 hintStyle: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 16,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: widget.color,
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear, color: widget.color),
//                   onPressed: () {
//                     setState(() {
//                       _searchController.clear();
//                       _searchQuery = "";
//                     });
//                   },
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: widget.color,
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey[400]!,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                   horizontal: 20,
//                 ),
//               ),
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 16,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: filteredList.isEmpty
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         "No Cattle Found Matching Your Criteria",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                 : Scrollbar(
//                     thumbVisibility: true,
//                     thickness: 8.0,
//                     radius: const Radius.circular(10),
//                     child: ListView.builder(
//                       itemCount: filteredList.length,
//                       itemBuilder: (context, index) {
//                         final cattle = filteredList[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           child: ListTile(
//                             leading: Icon(Icons.pets, color: widget.color),
//                             title: Text("ID: ${cattle["id"]}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Weight: ${cattle["weight"]} kg"),
//                                 Text("Gender: ${cattle["gender"]}"),
//                                 Text("Age: ${cattle["age"]} years"),
//                               ],
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.edit,
//                                     color: Colors.blue,
//                                   ),
//                                   onPressed: () {
//                                     _editCattle(
//                                       context,
//                                       cattle,
//                                       widget.category,
//                                       cattleProvider,
//                                     );
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                   ),
//                                   onPressed: () {
//                                     _confirmDelete(
//                                       context,
//                                       cattle["id"],
//                                       widget.category,
//                                       cattleProvider,
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             heroTag: "sortButton",
//             onPressed: () {
//               _showSortDialog(context);
//             },
//             backgroundColor: widget.color,
//             child: const Icon(Icons.sort, color: Colors.white),
//           ),
//           const SizedBox(width: 10),
//           FloatingActionButton(
//             heroTag: "filterButton",
//             onPressed: () {
//               _showFilterDialog(context);
//             },
//             backgroundColor: widget.color,
//             child: const Icon(Icons.filter_list, color: Colors.white),
//           ),
//           const SizedBox(width: 10),
//           FloatingActionButton(
//             heroTag: "addButton",
//             onPressed: () {
//               _addNewCattle(context, widget.category, cattleProvider);
//             },
//             backgroundColor: widget.color,
//             child: const Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Map<String, dynamic>> _filterCattleList(
//     List<Map<String, dynamic>> cattleList,
//   ) {
//     return cattleList.where((cattle) {
//       final idMatch = cattle["id"].toLowerCase().contains(
//         _searchQuery.toLowerCase(),
//       );
//       final genderMatch =
//           selectedGenders.isEmpty || selectedGenders.contains(cattle["gender"]);
//       final ageMatch =
//           selectedAges.isEmpty || selectedAges.contains(cattle["age"]);
//       return idMatch && genderMatch && ageMatch;
//     }).toList();
//   }
//
//   void _showFilterDialog(BuildContext context) {
//     final List<String> allGenders = ["Male", "Female"];
//     final List<String> allAges = ["1", "2", "3", "4"];
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Filter by Gender:",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         CheckboxListTile(
//                           title: const Text("Select All"),
//                           value: selectedGenders.length == allGenders.length,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (value == true) {
//                                 selectedGenders = List.from(allGenders);
//                               } else {
//                                 selectedGenders.clear();
//                               }
//                             });
//                           },
//                         ),
//                         ...allGenders.map((gender) {
//                           return CheckboxListTile(
//                             title: Text(gender),
//                             value: selectedGenders.contains(gender),
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 if (value == true) {
//                                   selectedGenders.add(gender);
//                                 } else {
//                                   selectedGenders.remove(gender);
//                                 }
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Filter by Age:",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         CheckboxListTile(
//                           title: const Text("Select All"),
//                           value: selectedAges.length == allAges.length,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (value == true) {
//                                 selectedAges = List.from(allAges);
//                               } else {
//                                 selectedAges.clear();
//                               }
//                             });
//                           },
//                         ),
//                         ...allAges.map((age) {
//                           return CheckboxListTile(
//                             title: Text(age),
//                             value: selectedAges.contains(age),
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 if (value == true) {
//                                   selectedAges.add(age);
//                                 } else {
//                                   selectedAges.remove(age);
//                                 }
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedGenders.clear();
//                   selectedAges.clear();
//                 });
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 "Clear Filters",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: widget.color,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 "Apply Filters",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showSortDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Text(
//             "Sort By",
//             style: TextStyle(
//               color: widget.color,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildSortOption("ID", "id"),
//               const Divider(height: 1, color: Colors.grey),
//               _buildSortOption("Weight", "weight"),
//               const Divider(height: 1, color: Colors.grey),
//               _buildSortOption("Age", "age"),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSortOption(String title, String sortBy) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.black87,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing:
//           _currentSortBy == sortBy
//               ? Icon(
//                 _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
//                 color: widget.color,
//               )
//               : null,
//       onTap: () {
//         _sortCattle(sortBy);
//         Navigator.pop(context);
//       },
//       tileColor:
//           _currentSortBy == sortBy ? widget.color.withOpacity(0.1) : null,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//     );
//   }
//
//   void _sortCattle(String sortBy) {
//     setState(() {
//       if (_currentSortBy == sortBy) {
//         _isAscending = !_isAscending;
//       } else {
//         _isAscending = true;
//         _currentSortBy = sortBy;
//       }
//
//       final cattleProvider = Provider.of<CattleProvider>(
//         context,
//         listen: false,
//       );
//       final cattleList = cattleProvider.cattleData[widget.category] ?? [];
//
//       if (sortBy == "id") {
//         cattleList.sort(
//           (a, b) =>
//               _isAscending
//                   ? a["id"].compareTo(b["id"])
//                   : b["id"].compareTo(a["id"]),
//         );
//       } else if (sortBy == "weight") {
//         cattleList.sort((a, b) {
//           final weightA = double.parse(a["weight"]);
//           final weightB = double.parse(b["weight"]);
//           return _isAscending
//               ? weightA.compareTo(weightB)
//               : weightB.compareTo(weightA);
//         });
//       } else if (sortBy == "age") {
//         cattleList.sort((a, b) {
//           final ageA = int.parse(a["age"]);
//           final ageB = int.parse(b["age"]);
//           return _isAscending ? ageA.compareTo(ageB) : ageB.compareTo(ageA);
//         });
//       }
//
//       cattleProvider.cattleData[widget.category] = cattleList;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           "Sorted by $sortBy (${_isAscending ? "Ascending" : "Descending"})",
//           style: const TextStyle(fontSize: 16),
//         ),
//         backgroundColor: widget.color,
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }
//
//   void _addNewCattle(
//     BuildContext context,
//     String category,
//     CattleProvider cattleProvider,
//   ) {
//     TextEditingController idController = TextEditingController();
//     TextEditingController weightController = TextEditingController();
//     String? selectedGender;
//     TextEditingController ageController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: Text(
//                 "Add New Cattle",
//                 style: TextStyle(
//                   color: widget.color,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: idController,
//                       decoration: InputDecoration(
//                         hintText: "Enter ID",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 15),
//                     TextField(
//                       controller: weightController,
//                       decoration: InputDecoration(
//                         hintText: "Enter Weight (e.g., 120)",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 10),
//
//                     DropdownButton<String>(
//                       value: selectedGender,
//                       hint: const Text("Choose Gender"),
//                       items:
//                           ["Male", "Female"].map((String gender) {
//                             return DropdownMenuItem<String>(
//                               value: gender,
//                               child: Text(
//                                 gender,
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                       onChanged: (String? value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                       dropdownColor: Colors.white,
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: ageController,
//                       decoration: InputDecoration(
//                         hintText: "Enter Age (e.g., 2)",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: widget.color),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "Cancel",
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     if (idController.text.isEmpty ||
//                         weightController.text.isEmpty ||
//                         ageController.text.isEmpty ||
//                         selectedGender == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please fill all fields")),
//                       );
//                       return;
//                     }
//
//                     // Check if ID already exists
//                     final cattleList =
//                         cattleProvider.cattleData[category] ?? [];
//                     if (cattleList.any(
//                       (cattle) => cattle["id"] == idController.text,
//                     )) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("ID already exists")),
//                       );
//                       return;
//                     }
//
//                     final weight = double.tryParse(weightController.text);
//                     final age = int.tryParse(ageController.text);
//                     if (weight == null || age == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Weight and Age must be valid numbers"),
//                         ),
//                       );
//                       return;
//                     }
//
//                     cattleProvider.addCattle(category, {
//                       "id": idController.text,
//                       "weight": weight.toString(),
//                       "gender": selectedGender,
//                       "age": age.toString(),
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Cattle added successfully"),
//                       ),
//                     );
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: widget.color,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Add",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _editCattle(
//     BuildContext context,
//     Map<String, dynamic> cattle,
//     String category,
//     CattleProvider cattleProvider,
//   ) {
//     TextEditingController idController = TextEditingController(
//       text: cattle["id"],
//     );
//     TextEditingController weightController = TextEditingController(
//       text: cattle["weight"],
//     );
//     String? selectedGender = cattle["gender"];
//     TextEditingController ageController = TextEditingController(
//       text: cattle["age"],
//     );
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Edit Cattle"),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: idController,
//                       decoration: InputDecoration(
//                         hintText: "Enter ID",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: weightController,
//                       decoration: InputDecoration(
//                         hintText: "Enter Weight (e.g., 120)",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     const SizedBox(height: 10),
//                     const Text("Select Gender:"),
//                     DropdownButton<String>(
//                       value: selectedGender,
//                       items:
//                           ["Male", "Female"].map((String gender) {
//                             return DropdownMenuItem<String>(
//                               value: gender,
//                               child: Text(gender),
//                             );
//                           }).toList(),
//                       onChanged: (String? value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: ageController,
//                       decoration: InputDecoration(
//                         hintText: "Enter Age (e.g., 2)",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     if (idController.text.isEmpty ||
//                         weightController.text.isEmpty ||
//                         ageController.text.isEmpty ||
//                         selectedGender == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please fill all fields")),
//                       );
//                       return;
//                     }
//
//                     final weight = double.tryParse(weightController.text);
//                     final age = int.tryParse(ageController.text);
//                     if (weight == null || age == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Weight and Age must be valid numbers"),
//                         ),
//                       );
//                       return;
//                     }
//
//                     cattleProvider.updateCattle(category, cattle["id"], {
//                       "id": idController.text,
//                       "weight": weight.toString(),
//                       "gender": selectedGender,
//                       "age": age.toString(),
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Cattle updated successfully"),
//                       ),
//                     );
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Save"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(
//     BuildContext context,
//     String id,
//     String category,
//     CattleProvider cattleProvider,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Confirm Delete"),
//           content: const Text("Are you sure you want to delete this cattle?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child:  Text("Cancel",style: TextStyle(color: widget.color),),
//             ),
//             TextButton(
//               onPressed: () {
//                 cattleProvider.deleteCattle(category, id);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Cattle deleted successfully")),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// //اخر تعديل

import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/get_cattle_model_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CattleDetailsScreen extends StatefulWidget {
  final String category;
  final Color color;

  const CattleDetailsScreen({
    super.key,
    required this.category,
    required this.color,
  });

  @override
  _CattleDetailsScreenState createState() => _CattleDetailsScreenState();
}
class _CattleDetailsScreenState extends State<CattleDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List<CattleModel> apiCattles = [];
  List<CattleModel> filteredCattles = [];
  bool isLoading = true;
  bool _hasChanges = false; // ✅ لتتبع التعديلات


  @override
  void initState() {
    super.initState();
    _loadCattlesByType();
  }

  Future<void> _loadCattlesByType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print("🔑 Token used: $token");


    if (token != null) {
      final cattles = await ApiManager.getCattlesByType(widget.category, token);
      setState(() {
        apiCattles = cattles;
        filteredCattles = List.from(apiCattles);
        isLoading = false;
      });
    } else {
      print("❌ No token found");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchCattleById(int id) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token not found")),
      );
      return;
    }

    final result = await ApiManager.getCattleByTypeAndId(widget.category, id, token);

    if (result != null) {
      setState(() {
        // apiCattles = [result]; // عرض النتيجة الوحيدة
        filteredCattles = [result];
        isLoading = false;
      });
    } else {
      setState(() {
        // apiCattles = [];
        filteredCattles = [];
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${widget.category} found with this ID")
        ),
      );
    }
  }

  List<CattleModel> _filterCattleList() {
    // return list.where((cattle) =>
    //     cattle.cattleID.toString().contains(_searchQuery)).toList();
    if (_searchQuery.isEmpty) return filteredCattles;
    return filteredCattles
        .where((cattle) => cattle.cattleID.toString().contains(_searchQuery))
        .toList();
  }

  void _addNewCattle(BuildContext context) {
    TextEditingController weightController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    String? selectedGender;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Add New Cattle",
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                        hintText: "Enter Weight (e.g., 120)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: widget.color),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: widget.color),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    DropdownButton<String>(
                      value: selectedGender,
                      hint: const Text("Choose Gender"),
                      items: ["Male", "Female"].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      dropdownColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        hintText: "Enter Age (e.g., 2)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: widget.color),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: widget.color),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context,true),
                  child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () async {
                    if (weightController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        selectedGender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final weight = weightController.text;
                    final age = ageController.text;
                    final gender = selectedGender!;
                    final type = widget.category;

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString("token");

                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Token not found")),
                      );
                      return;
                    }

                    final data = {
                      "Type": type,
                      "Weight": weight,
                      "Age": age,
                      "Gender": gender,
                    };

                    final result = await ApiManager.addCattle(data, token);

                    if (result != null && result.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message!)),
                      );
                      setState(() {
                        _hasChanges = true;
                      });
                      await _loadCattlesByType(); // تحديث القائمة بعد الإضافة
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to add cattle")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editCattle(BuildContext context, CattleModel cattle) async {
    final TextEditingController idController =
    TextEditingController(text: cattle.cattleID.toString());
    final TextEditingController weightController =
    TextEditingController(text: cattle.weight.toString());
    final TextEditingController ageController =
    TextEditingController(text: cattle.age.toString());
    String? selectedGender = cattle.gender;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit Cattle"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: "Enter ID",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      enabled: false, // ID is not editable
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                        hintText: "Enter Weight (e.g., 120)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    const Text("Select Gender:"),
                    DropdownButton<String>(
                      value: selectedGender,
                      items: ["Male", "Female"].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender[0].toUpperCase() + gender.substring(1)), // عرض الشكل الجميل
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        hintText: "Enter Age (e.g., 2)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    if (weightController.text.isEmpty || ageController.text.isEmpty || selectedGender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final weight = int.tryParse(weightController.text);
                    final age = int.tryParse(ageController.text);
                    if (weight == null || age == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Weight and Age must be valid numbers")),
                      );
                      return;
                    }

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString("token");

                    final updatedData = {
                      "weight": weight,
                      "gender": selectedGender![0].toUpperCase() + selectedGender!.substring(1).toLowerCase(),
                      "age": age,
                      "type": widget.category[0].toUpperCase() + widget.category.substring(1).toLowerCase(),
                    };

                    final response = await ApiManager.updateCattle(cattle.cattleID!, updatedData, token!);
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cattle updated successfully")),
                      );
                      if (response != null){
                        setState(() {
                          _hasChanges = true;
                        });
                        await _loadCattlesByType();
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Update failed. Please try again.")),
                      );
                    }
                  },

                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext rootContext, int? id, String category) async {
    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this cattle?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext,true); // استخدم dialogContext هنا
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext,true);

                try {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString("token");

                  if (token == null || id == null) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      const SnackBar(content: Text("Invalid request")),
                    );
                    return;
                  }

                  final response = await ApiManager.deleteCattle(id, token);

                  if (response != null) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      const SnackBar(content: Text("Cattle deleted successfully")),
                    );

                    if(response != null){
                      setState(() {
                        _hasChanges = true;
                      });
                      await _loadCattlesByType();
                    }
                  } else {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      const SnackBar(content: Text("Failed to delete cattle")),
                    );
                  }
                } catch (e) {
                  print("❌ Error: $e");
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    const SnackBar(content: Text("An error occurred")),
                  );
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Sort Cattles By"),
          children: [
            SimpleDialogOption(
              child: const Text("Weight (Low to High)"),
              onPressed: () {
                setState(() {
                  filteredCattles.sort((a, b) => a.weight!.compareTo(b.weight!));
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("Weight (High to Low)"),
              onPressed: () {
                setState(() {
                  filteredCattles.sort((a, b) => b.weight!.compareTo(a.weight!));
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("Age (Young to Old)"),
              onPressed: () {
                setState(() {
                  filteredCattles.sort((a, b) => a.age!.compareTo(b.age!));
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("Age (Old to Young)"),
              onPressed: () {
                setState(() {
                  filteredCattles.sort((a, b) => b.age!.compareTo(a.age!));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Filter By Gender"),
          children: [
            SimpleDialogOption(
              child: const Text("All"),
              onPressed: () {
                setState(() {
                  filteredCattles = List.from(apiCattles);
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("Male"),
              onPressed: () {
                setState(() {
                  filteredCattles = apiCattles
                      .where((c) => c.gender?.toLowerCase() == "male")
                      .toList();
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("Female"),
              onPressed: () {
                setState(() {
                  filteredCattles = apiCattles
                      .where((c) => c.gender?.toLowerCase() == "female")
                      .toList();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    // final filteredList = _filterCattleList(apiCattles);
    final filteredList = _filterCattleList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: widget.color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, _hasChanges);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by ID...",
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                prefixIcon: Icon(Icons.search, color: widget.color),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: widget.color),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = "";
                      filteredCattles = List.from(apiCattles);
                      // _loadCattlesByType(); // نرجع نعرض كل البيانات
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.color, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              style: const TextStyle(fontSize: 16),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  final id = int.tryParse(value);
                  if (id != null) {
                    searchCattleById(id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid numeric ID")),
                    );
                  }
                }
              },
            ),

          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No Cattle Found Matching Your Criteria",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Scrollbar(
              thumbVisibility: true,
              thickness: 8.0,
              radius: const Radius.circular(10),
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final cattle = filteredList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.pets, color: widget.color),
                      title: Text("ID: ${cattle.cattleID}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weight: ${cattle.weight} kg"),
                          Text("Gender: ${cattle.gender}"),
                          Text("Age: ${cattle.age} years"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editCattle(context, cattle),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, cattle.cattleID,widget.category),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "sortButton",
            onPressed: () => _showSortDialog(context),
            backgroundColor: widget.color,
            child: const Icon(Icons.sort, color: Colors.white),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "filterButton",
            onPressed: () => _showFilterDialog(context),
            backgroundColor: widget.color,
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "addButton",
            onPressed: () => _addNewCattle(context),
            backgroundColor: widget.color,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
