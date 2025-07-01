// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../data/providers/staff_provider.dart';
// import '../widgets/worker_card.dart';
//
//
// class WorkersScreen extends StatefulWidget {
//   const WorkersScreen({super.key});
//
//   @override
//   State<WorkersScreen> createState() => _WorkersScreenState();
// }
//
// class _WorkersScreenState extends State<WorkersScreen> {
//
//
//   final TextEditingController searchController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   Timer? _searchTimer;
//
//   final FocusNode _nameFocusNode = FocusNode();
//   final FocusNode _specialtyFocusNode = FocusNode();
//   final FocusNode _phoneFocusNode = FocusNode();
//   final FocusNode _salaryFocusNode = FocusNode();
//   final FocusNode _ageFocusNode = FocusNode();
//   final FocusNode _nationalIdFocusNode = FocusNode();
//   final FocusNode _codeFocusNode = FocusNode();
//   final FocusNode _experienceFocusNode = FocusNode();
//
//   double _fabScale = 1.0;
//   bool _isPressed = false;
//   @override
//   void dispose() {
//     _nameFocusNode.dispose();
//     _specialtyFocusNode.dispose();
//     _phoneFocusNode.dispose();
//     _salaryFocusNode.dispose();
//     _ageFocusNode.dispose();
//     _nationalIdFocusNode.dispose();
//     _codeFocusNode.dispose();
//     _experienceFocusNode.dispose();
//     searchController.dispose();
//     _searchTimer?.cancel();
//     super.dispose();
//   }
//
//   InputDecoration _buildInputDecoration(
//     String labelText,
//     IconData icon,
//     FocusNode focusNode,
//   ) {
//     return InputDecoration(
//       labelText: labelText,
//       labelStyle: TextStyle(
//         color: focusNode.hasFocus ? Colors.green : Colors.grey,
//       ),
//       prefixIcon: Icon(icon, color: Colors.green),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.green, width: 2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final workerProvider = Provider.of<WorkerProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           "Farm Workers",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.sort, color: Colors.white),
//             onPressed: () => workerProvider.sortByName(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: searchController,
//               decoration: _buildInputDecoration(
//                 "Search By Name , Code , ID...",
//                 Icons.search,
//                 FocusNode(),
//               ),
//               onChanged: (query) {
//                 _searchTimer?.cancel();
//                 _searchTimer = Timer(const Duration(milliseconds: 500), () {
//                   workerProvider.filterSearch(query);
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: Scrollbar(
//               thickness: 8.0,
//               radius: const Radius.circular(10),
//               trackVisibility: true,
//               thumbVisibility: true,
//               interactive: true,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: workerProvider.filteredWorkers.length,
//                 itemBuilder: (context, index) {
//                   final worker = workerProvider.filteredWorkers[index];
//                   return WorkerCard(
//                     worker: worker,
//                     onDelete: () => _confirmDelete(context, index),
//                     onEdit:
//                         () => _showAddWorkerDialog(
//                           context,
//                           workerProvider,
//                           index,
//                         ),
//                     onImagePick: () => _pickImage(index),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: GestureDetector(
//         onTapDown: (_) {
//           setState(() {
//             _fabScale = 0.95;
//             _isPressed = true;
//           });
//         },
//         onTapUp: (_) {
//           setState(() {
//             _fabScale = 1.0;
//             _isPressed = false;
//           });
//           _showAddWorkerDialog(context, workerProvider, null);
//         },
//         onTapCancel: () {
//           setState(() {
//             _fabScale = 1.0;
//             _isPressed = false;
//           });
//         },
//         child: AnimatedScale(
//           scale: _fabScale,
//           duration: Duration(milliseconds: 150),
//           child: AnimatedContainer(
//             duration: Duration(milliseconds: 200),
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors:
//                     _isPressed
//                         ? [Color(0xFF2E7D32), Color(0xFF1B5E20)]
//                         : [Color(0xFF4CAF50), Color(0xFF2E7D32)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow:
//                   _isPressed
//                       ? []
//                       : [
//                         BoxShadow(
//                           color: Color(0xFF4CAF50).withOpacity(0.4),
//                           blurRadius: 12,
//                           spreadRadius: 1,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//             ),
//             child: Icon(
//               Icons.add,
//               size: 36,
//               color: Colors.white.withOpacity(_isPressed ? 0.8 : 1.0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showAddWorkerDialog(
//     BuildContext context,
//     WorkerProvider provider,
//     int? index,
//   ) {
//     final _formKey = GlobalKey<FormState>();
//     bool _isSaving = false;
//
//     TextEditingController nameController = TextEditingController();
//     TextEditingController specialtyController = TextEditingController();
//     TextEditingController phoneController = TextEditingController();
//     TextEditingController salaryController = TextEditingController();
//     TextEditingController ageController = TextEditingController();
//     TextEditingController nationalIdController = TextEditingController();
//     TextEditingController codeController = TextEditingController();
//     TextEditingController experienceController = TextEditingController();
//
//     if (index != null) {
//       final worker = provider.workers[index];
//       nameController.text = worker["name"] ?? '';
//       specialtyController.text = worker["specialty"] ?? '';
//       phoneController.text = worker["phone"] ?? '';
//       salaryController.text = worker["salary"]?.toString() ?? '';
//       ageController.text = worker["age"]?.toString() ?? '';
//       nationalIdController.text = worker["nationalId"] ?? '';
//       codeController.text = worker["code"] ?? '';
//       experienceController.text = worker["experienceYears"]?.toString() ?? '';
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     index == null ? "Add Worker" : "Edit Worker",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextFormField(
//                     focusNode: _nameFocusNode,
//                     controller: nameController,
//                     decoration: _buildInputDecoration(
//                       "Name",
//                       Icons.person,
//                       _nameFocusNode,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a name";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _specialtyFocusNode,
//                     controller: specialtyController,
//                     decoration: _buildInputDecoration(
//                       "Specialty",
//                       Icons.work,
//                       _specialtyFocusNode,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a specialty";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _phoneFocusNode,
//                     controller: phoneController,
//                     decoration: _buildInputDecoration(
//                       "Phone",
//                       Icons.phone,
//                       _phoneFocusNode,
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a phone number";
//                       }
//                       if (value.length != 11 ||
//                           !RegExp(r'^[0-9]+$').hasMatch(value)) {
//                         return "Phone number must be 11 digits";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _salaryFocusNode,
//                     controller: salaryController,
//                     decoration: _buildInputDecoration(
//                       "Salary",
//                       Icons.attach_money,
//                       _salaryFocusNode,
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a salary";
//                       }
//                       if (int.tryParse(value) == null) {
//                         return "Please enter a valid number";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _ageFocusNode,
//                     controller: ageController,
//                     decoration: _buildInputDecoration(
//                       "Age",
//                       Icons.calendar_today,
//                       _ageFocusNode,
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter an age";
//                       }
//                       if (int.tryParse(value) == null) {
//                         return "Please enter a valid number";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _nationalIdFocusNode,
//                     controller: nationalIdController,
//                     decoration: _buildInputDecoration(
//                       "National ID",
//                       Icons.credit_card,
//                       _nationalIdFocusNode,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a national ID";
//                       }
//                       if (value.length != 14 ||
//                           !RegExp(r'^[0-9]+$').hasMatch(value)) {
//                         return "National ID must be 14 digits";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _codeFocusNode,
//                     controller: codeController,
//                     decoration: InputDecoration(
//                       labelText: "Code",
//                       prefixIcon: const Icon(Icons.tag, color: Colors.green),
//                       labelStyle: TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                           color: Colors.green,
//                           width: 2,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter a code";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     focusNode: _experienceFocusNode,
//                     controller: experienceController,
//                     decoration: _buildInputDecoration(
//                       "Experience (years)",
//                       Icons.work,
//                       _experienceFocusNode,
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter experience years";
//                       }
//                       if (int.tryParse(value) == null) {
//                         return "Please enter a valid number";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text(
//                           "Cancel",
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed:
//                             _isSaving
//                                 ? null
//                                 : () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     setState(() => _isSaving = true);
//
//                                     final newWorker = {
//                                       "name": nameController.text,
//                                       "specialty": specialtyController.text,
//                                       "phone": phoneController.text,
//                                       "salary":
//                                           int.tryParse(salaryController.text) ??
//                                           0,
//                                       "age":
//                                           int.tryParse(ageController.text) ?? 0,
//                                       "nationalId": nationalIdController.text,
//                                       "code": codeController.text,
//                                       "experienceYears":
//                                           int.tryParse(
//                                             experienceController.text,
//                                           ) ??
//                                           0,
//                                       "image":
//                                           index != null
//                                               ? provider.workers[index]["image"]
//                                               : null,
//                                       "rating":
//                                           index != null
//                                               ? provider
//                                                       .workers[index]["rating"] ??
//                                                   0.0
//                                               : 0.0,
//                                       "hireDate":
//                                           index != null
//                                               ? (provider
//                                                       .workers[index]["hireDate"] ??
//                                                   DateTime.now().toString())
//                                               : DateTime.now().toString(),
//                                     };
//
//                                     if (index == null) {
//                                       provider.addWorker(newWorker, context);
//                                     } else {
//                                       provider.updateWorker(
//                                         index,
//                                         newWorker,
//                                         context,
//                                       );
//                                     }
//
//                                     setState(() => _isSaving = false);
//                                     Navigator.pop(context);
//                                   }
//                                 },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child:
//                             _isSaving
//                                 ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                                 : Text(
//                                   index == null ? "Add" : "Update",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _pickImage(int index) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         final provider = Provider.of<WorkerProvider>(context, listen: false);
//         provider.workers[index]["image"] = image.path;
//         provider.filterSearch(searchController.text);
//         provider.saveWorkers();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking image: ${e.toString()}")),
//       );
//     }
//   }
//
//   void _confirmDelete(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Confirm Delete"),
//           content: const Text("Are you sure you want to delete this worker?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Provider.of<WorkerProvider>(
//                   context,
//                   listen: false,
//                 ).deleteWorker(index, context);
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 "Delete",
//                 style: TextStyle(color: Colors.green),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//

import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
import 'package:farmxpert/features/staff/widgets/worker_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class WorkersScreen extends StatefulWidget {
  @override
  _WorkersScreenState createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  List<GetAllResponse> workers = [];
  bool isLoading = true;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final specialtyController = TextEditingController();
  final nationalIDController = TextEditingController();
  final ageController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWorkers();
  }

  Future<void> loadWorkers() async {
    print("🌀 Entered loadWorkers");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("لم يتم العثور على التوكن")),
        );
        return;
      }
      final data = await ApiManager.getAllWorkers(token);
      setState(() {
        workers = data;
        print("🔁 Reloaded workers, new count: ${workers.length}");
        isLoading = false;
      });
    } catch (e) {
      print("Error loading workers: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء تحميل العمال")),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> showAddWorkerDialog() async {
    bool _obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Add Worker"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter name" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter email";
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                      return emailRegex.hasMatch(value)
                          ? null
                          : "Enter valid email";
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      counterText: '', // يخفي العداد تحت
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter phone";
                      if (value.length != 11) return "Phone must be 11 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter password"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: specialtyController,
                    decoration: InputDecoration(
                      labelText: "Specialty",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter specialty"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nationalIDController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    decoration: InputDecoration(
                      labelText: "National ID",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      counterText: '', // يخفي العداد تحت
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter national ID";
                      if (value.length != 14)
                        return "National ID must be 14 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter age" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: experienceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Experience",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter experience"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Salary",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter salary" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString("token") ?? "";

                  if (token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("لم يتم العثور على التوكن")),
                    );
                    return;
                  }

                  final workerData = {
                    "Name": nameController.text.trim(),
                    "Email": emailController.text.trim(),
                    "Phone": phoneController.text.trim(),
                    "Password": passwordController.text.trim(),
                    "Specialty": specialtyController.text.trim(),
                    "NationalID": nationalIDController.text.trim(),
                    "Age": ageController.text.trim(),
                    "Experience": experienceController.text.trim(),
                    "Salary": salaryController.text.trim(),
                  };

                  try {
                    final response =
                        await ApiManager.addWorker(workerData, token);

                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تمت إضافة العامل بنجاح!")),
                      );
                      await loadWorkers();
                      Navigator.pop(context);
                      clearFields();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("حدث خطأ أثناء إضافة العامل")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("حدث خطأ أثناء الاتصال بالخادم")),
                    );
                  }
                }
              },
              child: Text("Save"),
            )
          ],
        );
      }),
    );
  }

  void showEditWorkerDialog(BuildContext context, Map<String, dynamic> worker) {
    final nameController = TextEditingController(text: worker['name']);
    final phoneController = TextEditingController(text: worker['phoneNumber']);
    // final addressController = TextEditingController(text: worker['address']);
    final jobController = TextEditingController(text: worker['job']);
    final emailController = TextEditingController(text: worker['email']);
    final salaryController =
        TextEditingController(text: worker['salary'].toString());
    final nationalIdController =
        TextEditingController(text: worker['nationalId']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تعديل العامل"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'الاسم')),
                TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'رقم الهاتف')),
                // TextField(controller: addressController, decoration: InputDecoration(labelText: 'العنوان')),
                TextField(
                    controller: jobController,
                    decoration: InputDecoration(labelText: 'الوظيفة')),
                TextField(
                    controller: emailController,
                    decoration:
                        InputDecoration(labelText: 'البريد الإلكتروني')),
                TextField(
                    controller: salaryController,
                    decoration: InputDecoration(labelText: 'المرتب')),
                TextField(
                    controller: nationalIdController,
                    decoration: InputDecoration(labelText: 'الرقم القومي')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token"); // توحيد اسم التوكن

                Map<String, String> updatedData = {
                  "Name": nameController.text,
                  "PhoneNumber": phoneController.text,
                  "Job": jobController.text,
                  "Email": emailController.text,
                  "Salary": salaryController.text,
                  "NationalId": nationalIdController.text,
                };

                // التحقق من البيانات التي سيتم إرسالها
                print("Sending data to update worker: $updatedData");

                final response = await ApiManager.updateWorker(
                  worker['id'],
                  updatedData,
                  token!,
                );

                if (response != null &&
                    response.message == "Worker updated successfully") {
                  await loadWorkers();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تعديل بيانات العامل بنجاح')),
                  );
                } else {
                  print("Error response: ${response?.message}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل في تعديل البيانات')),
                  );
                }
              },
              child: Text("حفظ"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
          ],
        );
      },
    );
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    specialtyController.clear();
    nationalIDController.clear();
    ageController.clear();
    experienceController.clear();
    salaryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Farm Workers",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.sort, color: Colors.white),
        //     onPressed: () => workerProvider.sortByName(),
        //   ),
        // ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : workers.isEmpty
              ? Center(child: Text("No workers found"))
              : ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    return WorkerCard(
                      worker: worker, // هنا worker من نوع GetAllResponse
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm Deletion"),
                            content: const Text("Are you sure you want to delete this worker?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              TextButton(
                                child: const Text("Delete"),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            final prefs = await SharedPreferences.getInstance();
                            final token = prefs.getString('token');

                            print("🚨 Token: $token");

                            if (token == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Authorization token is missing.")),
                              );
                              return;
                            }

                            final deleteResponse =
                            await ApiManager.deleteWorker(worker.id!, token);

                            if (deleteResponse != null && deleteResponse.success) {
                              await loadWorkers(); // ✅ يعيد تحميل القائمة من السيرفر
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(deleteResponse.message)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(deleteResponse?.message ??
                                        "Failed to delete worker.")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error deleting worker: $e")),
                            );
                          }
                        }
                      },

                      onEdit: () => showEditWorkerDialog(context, {
                        'id': worker.id,
                        'name': worker.name,
                        'phoneNumber': worker.phone,
                        'job': worker.specialty,
                        'email': worker.email,
                        'salary': worker.salary,
                        'nationalId': worker.nationalID,
                      }),

                      onImagePick: () {
                        // TODO: لو عايز تختار صورة جديدة أو تعدلها بعدين
                      },
                    );

                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddWorkerDialog, // دالة إضافة عامل جديدة
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // نفس اللون زي الأول
      ),
    );
  }
}



// WorkerCard(
//   worker: worker,
//   onDelete: () async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Confirm Deletion"),
//         content: const Text(
//             "Are you sure you want to delete this worker?"),
//         actions: [
//           TextButton(
//             child: const Text("Cancel"),
//             onPressed: () => Navigator.of(ctx).pop(false),
//           ),
//           TextButton(
//             child: const Text("Delete"),
//             onPressed: () => Navigator.of(ctx).pop(true),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('token');
//
//         print(
//             "🚨 Token: $token"); // قم بطباعة الـ token للتحقق من وجوده
//
//         if (token == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text(
//                     "Authorization token is missing.")),
//           );
//           return;
//         }
//
//         final deleteResponse =
//             await ApiManager.deleteWorker(
//                 worker.id!, token);
//
//         if (deleteResponse != null &&
//             deleteResponse.success) {
//           setState(() {
//             workers.removeWhere((w) => w.id == worker.id);
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(deleteResponse.message)),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(deleteResponse?.message ??
//                     "Failed to delete worker.")),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Error deleting worker: $e")),
//         );
//       }
//     }
//   },
//
//   onEdit: () => showEditWorkerDialog(context, {
//     'id': worker.id,
//     'name': worker.name,
//     'phoneNumber': worker.phone,
//     // 'address': worker.address ?? "", // إذا address مش موجود، مرر قيمة فارغة
//     'job': worker.specialty,
//     'email': worker.email,
//     'salary': worker.salary,
//     'nationalId': worker.nationalID,
//   }),
//   onImagePick: () {},
//   // onDelete: () => _confirmDelete(context, index), // لو في دالة للحذف
//   // onEdit: () => _showAddWorkerDialog(context, index), // لو في دالة للتعديل
//   // onImagePick: () => _pickImage(index), // لو في دالة لاختيار صورة
// );
