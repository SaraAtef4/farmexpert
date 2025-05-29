// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../../data/providers/staff_provider.dart';
// import '../widgets/veterian_card.dart';
//
//
// class VeterianScreen extends StatefulWidget {
//   const VeterianScreen({super.key});
//
//   @override
//   State<VeterianScreen> createState() => _VeterianScreenState();
// }
//
// class _VeterianScreenState extends State<VeterianScreen> {
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
//
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
//     final veterinarianProvider = Provider.of<VeterinarianProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           "Farm Veterinarians",
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
//             onPressed: () => veterinarianProvider.sortByName(),
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
//                   veterinarianProvider.filterSearch(query);
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
//                 itemCount: veterinarianProvider.filteredVeterinarians.length,
//                 itemBuilder: (context, index) {
//                   final vet = veterinarianProvider.filteredVeterinarians[index];
//                   return VeterinarianCard(
//                     vet: vet,
//                     onDelete: () => _confirmDelete(context, index),
//                     onEdit:
//                         () => _showAddVeterinarianDialog(
//                           context,
//                           veterinarianProvider,
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
//           _showAddVeterinarianDialog(context, veterinarianProvider, null);
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
//                         ? [
//                           Color(0xFF2E7D32), // أخضر غامق عند الضغط
//                           Color(0xFF1B5E20),
//                         ]
//                         : [
//                           Color(0xFF4CAF50), // أخضر فاتح عادي
//                           Color(0xFF2E7D32),
//                         ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow:
//                   _isPressed
//                       ? [] // إزالة الظل عند الضغط
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
//   void _showAddVeterinarianDialog(
//     BuildContext context,
//     VeterinarianProvider provider,
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
//       final vet = provider.veterinarians[index];
//       nameController.text = vet["name"] ?? '';
//       specialtyController.text = vet["specialty"] ?? '';
//       phoneController.text = vet["phone"] ?? '';
//       salaryController.text = vet["salary"]?.toString() ?? '';
//       ageController.text = vet["age"]?.toString() ?? '';
//       nationalIdController.text = vet["nationalId"] ?? '';
//       codeController.text = vet["code"] ?? '';
//       experienceController.text = vet["experienceYears"]?.toString() ?? '';
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
//                     index == null ? "Add Veterinarian" : "Edit Veterinarian",
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
//                       Icons.medical_services,
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
//                         return "Phone must be 11 digits";
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
//                                     final newVet = {
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
//                                               ? provider
//                                                   .veterinarians[index]["image"]
//                                               : null,
//                                       "rating":
//                                           index != null
//                                               ? provider
//                                                       .veterinarians[index]["rating"] ??
//                                                   0.0
//                                               : 0.0,
//                                       "hireDate":
//                                           index != null
//                                               ? (provider
//                                                       .veterinarians[index]["hireDate"] ??
//                                                   DateTime.now().toString())
//                                               : DateTime.now().toString(),
//                                     };
//
//                                     if (index == null) {
//                                       provider.addVeterinarian(newVet, context);
//                                     } else {
//                                       provider.updateVeterinarian(
//                                         index,
//                                         newVet,
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
//         final provider = Provider.of<VeterinarianProvider>(
//           context,
//           listen: false,
//         );
//         provider.veterinarians[index]["image"] = image.path;
//         provider.filterSearch(searchController.text);
//         provider.saveVeterinarians();
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
//           content: const Text(
//             "Are you sure you want to delete this veterinarian?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Provider.of<VeterinarianProvider>(
//                   context,
//                   listen: false,
//                 ).deleteVeterinarian(index, context);
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

import 'dart:async';
import 'package:farmxpert/data/providers/staff_provider.dart';
import 'package:farmxpert/features/staff/widgets/veterian_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class VeterianScreen extends StatefulWidget {
  const VeterianScreen({super.key});

  @override
  State<VeterianScreen> createState() => _VeterianScreenState();
}

class _VeterianScreenState extends State<VeterianScreen> {
  final TextEditingController searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Timer? _searchTimer;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _specialtyFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _salaryFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _nationalIdFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _experienceFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  double _fabScale = 1.0;
  bool _isPressed = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _specialtyFocusNode.dispose();
    _phoneFocusNode.dispose();
    _salaryFocusNode.dispose();
    _ageFocusNode.dispose();
    _nationalIdFocusNode.dispose();
    _codeFocusNode.dispose();
    _experienceFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
    String labelText,
    IconData icon,
    FocusNode focusNode,
  ) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: focusNode.hasFocus ? Colors.green : Colors.grey,
      ),
      prefixIcon: Icon(icon, color: Colors.green),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final veterinarianProvider = Provider.of<VeterinarianProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Farm Veterinarians",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () => veterinarianProvider.sortByName(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: _buildInputDecoration(
                "Search By Name, Code, Email...",
                Icons.search,
                FocusNode(),
              ),
              onChanged: (query) {
                _searchTimer?.cancel();
                _searchTimer = Timer(const Duration(milliseconds: 500), () {
                  veterinarianProvider.filterSearch(query);
                });
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 8.0,
              radius: const Radius.circular(10),
              trackVisibility: true,
              thumbVisibility: true,
              interactive: true,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: veterinarianProvider.filteredVeterinarians.length,
                itemBuilder: (context, index) {
                  final vet = veterinarianProvider.filteredVeterinarians[index];
                  return VeterinarianCard(
                    vet: vet,
                    onDelete: () => _confirmDelete(context, index),
                    onEdit: () => _showAddVeterinarianDialog(
                      context,
                      veterinarianProvider,
                      index,
                    ),
                    onImagePick: () => _pickImage(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _fabScale = 0.95;
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _fabScale = 1.0;
            _isPressed = false;
          });
          _showAddVeterinarianDialog(context, veterinarianProvider, null);
        },
        onTapCancel: () {
          setState(() {
            _fabScale = 1.0;
            _isPressed = false;
          });
        },
        child: AnimatedScale(
          scale: _fabScale,
          duration: Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isPressed
                    ? [Color(0xFF2E7D32), Color(0xFF1B5E20)]
                    : [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              Icons.add,
              size: 36,
              color: Colors.white.withOpacity(_isPressed ? 0.8 : 1.0),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddVeterinarianDialog(
    BuildContext context,
    VeterinarianProvider provider,
    int? index,
  ) {
    final _formKey = GlobalKey<FormState>();
    bool _isSaving = false;

    TextEditingController nameController = TextEditingController();
    TextEditingController specialtyController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController salaryController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController nationalIdController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController experienceController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    if (index != null) {
      final vet = provider.veterinarians[index];
      nameController.text = vet["name"] ?? '';
      specialtyController.text = vet["specialty"] ?? '';
      phoneController.text = vet["phone"] ?? '';
      salaryController.text = vet["salary"]?.toString() ?? '';
      ageController.text = vet["age"]?.toString() ?? '';
      nationalIdController.text = vet["nationalId"] ?? '';
      codeController.text = vet["code"] ?? '';
      experienceController.text = vet["experienceYears"]?.toString() ?? '';
      emailController.text = vet["email"] ?? '';
      passwordController.text = vet["password"] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    index == null ? "Add Veterinarian" : "Edit Veterinarian",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    focusNode: _nameFocusNode,
                    controller: nameController,
                    decoration: _buildInputDecoration(
                      "Name",
                      Icons.person,
                      _nameFocusNode,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _specialtyFocusNode,
                    controller: specialtyController,
                    decoration: _buildInputDecoration(
                      "Specialty",
                      Icons.medical_services,
                      _specialtyFocusNode,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a specialty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _phoneFocusNode,
                    controller: phoneController,
                    decoration: _buildInputDecoration(
                      "Phone",
                      Icons.phone,
                      _phoneFocusNode,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a phone number";
                      }
                      if (value.length != 11 ||
                          !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "Phone must be 11 digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _salaryFocusNode,
                    controller: salaryController,
                    decoration: _buildInputDecoration(
                      "Salary",
                      Icons.attach_money,
                      _salaryFocusNode,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a salary";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _ageFocusNode,
                    controller: ageController,
                    decoration: _buildInputDecoration(
                      "Age",
                      Icons.calendar_today,
                      _ageFocusNode,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an age";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _nationalIdFocusNode,
                    controller: nationalIdController,
                    decoration: _buildInputDecoration(
                      "National ID",
                      Icons.credit_card,
                      _nationalIdFocusNode,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a national ID";
                      }
                      if (value.length != 14 ||
                          !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "National ID must be 14 digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _codeFocusNode,
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Code",
                      prefixIcon: const Icon(Icons.tag, color: Colors.green),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _experienceFocusNode,
                    controller: experienceController,
                    decoration: _buildInputDecoration(
                      "Experience (years)",
                      Icons.work,
                      _experienceFocusNode,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter experience years";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _emailFocusNode,
                    controller: emailController,
                    decoration: _buildInputDecoration(
                      "Email",
                      Icons.email,
                      _emailFocusNode,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: passwordController,
                    decoration: _buildInputDecoration(
                      "Password",
                      Icons.lock,
                      _passwordFocusNode,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isSaving = true);

                                  final newVet = {
                                    "name": nameController.text,
                                    "specialty": specialtyController.text,
                                    "phone": phoneController.text,
                                    "salary":
                                        int.tryParse(salaryController.text) ??
                                            0,
                                    "age":
                                        int.tryParse(ageController.text) ?? 0,
                                    "nationalId": nationalIdController.text,
                                    "code": codeController.text,
                                    "experienceYears": int.tryParse(
                                            experienceController.text) ??
                                        0,
                                    "email": emailController.text,
                                    "password": passwordController.text,
                                    "image": index != null
                                        ? provider.veterinarians[index]["image"]
                                        : null,
                                    "rating": index != null
                                        ? provider.veterinarians[index]
                                                ["rating"] ??
                                            0.0
                                        : 0.0,
                                    "hireDate": index != null
                                        ? (provider.veterinarians[index]
                                                ["hireDate"] ??
                                            DateTime.now().toString())
                                        : DateTime.now().toString(),
                                  };

                                  if (index == null) {
                                    provider.addVeterinarian(newVet, context);
                                  } else {
                                    provider.updateVeterinarian(
                                      index,
                                      newVet,
                                      context,
                                    );
                                  }

                                  setState(() => _isSaving = false);
                                  Navigator.pop(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                index == null ? "Add" : "Update",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final provider = Provider.of<VeterinarianProvider>(
          context,
          listen: false,
        );
        provider.veterinarians[index]["image"] = image.path;
        provider.filterSearch(searchController.text);
        provider.saveVeterinarians();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: ${e.toString()}")),
      );
    }
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
            "Are you sure you want to delete this veterinarian?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<VeterinarianProvider>(
                  context,
                  listen: false,
                ).deleteVeterinarian(index, context);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
