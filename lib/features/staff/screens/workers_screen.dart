import 'dart:io';

import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
import 'package:farmxpert/features/staff/widgets/worker_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/custom_app_bar.dart';

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

  File? selectedImage; // الصورة المختارة
  File? editedImage;

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
          SnackBar(content: Text("Token not found")),
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
        SnackBar(content: Text(" An error occurred while loading workers")),
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
                    decoration: _inputDecoration("Name"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter name"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration("Email"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter email";
                      final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                      return emailRegex.hasMatch(value)
                          ? null
                          : "Email must end with @gmail.com";
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
                    decoration:
                        _inputDecoration("Phone").copyWith(counterText: ''),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter phone number";
                      if (value.length != 11)
                        return "Phone number must be 11 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration("Password").copyWith(
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
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter password"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: specialtyController,
                    decoration: _inputDecoration("Specialty"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter specialty"
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
                    decoration: _inputDecoration("National ID")
                        .copyWith(counterText: ''),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter national ID";
                      if (value.length != 14)
                        return "National ID must be 14 digits";
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Age"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter age"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: experienceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Experience"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter experience"
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Salary"),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter salary"
                        : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() {
                          selectedImage = File(picked.path);
                        });
                      }
                    },
                    icon: Icon(Icons.image),
                    label: Text("Choose Image"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  if (selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(selectedImage!, height: 100),
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
                      SnackBar(content: Text("Token not found")),
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
                    final response = await ApiManager.addWorker(
                        workerData, token,
                        image: selectedImage);

                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Worker added successfully!")),
                      );
                      await loadWorkers();
                      Navigator.pop(context);
                      clearFields();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Error occurred while adding the worker")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Error occurred while connecting to the server")),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
    );
  }

  void showEditWorkerDialog(BuildContext context, Map<String, dynamic> worker) {
    final _formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: worker['name']);
    final phoneController = TextEditingController(text: worker['phoneNumber']);
    final specialtyController =
        TextEditingController(text: worker['specialty']);
    final emailController = TextEditingController(text: worker['email']);
    final salaryController =
        TextEditingController(text: worker['salary'].toString());
    final nationalIdController =
        TextEditingController(text: worker['nationalId']);

    InputDecoration _inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Worker"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration('Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    maxLength: 11, // ✅ يمنع إدخال أكثر من 11 رقم
                    decoration: _inputDecoration('Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'Phone number must be 11 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: specialtyController,
                    decoration: _inputDecoration('Specialty'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Specialty is required'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                          .hasMatch(value)) {
                        return 'Email must be in the format user@gmail.com';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: salaryController,
                    decoration: _inputDecoration('Salary'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Salary is required';
                      }
                      try {
                        double.parse(value);
                        return null;
                      } catch (e) {
                        return 'Salary must be a number';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nationalIdController,
                    maxLength: 14, // ✅ يمنع إدخال أكثر من 14 رقم
                    decoration: _inputDecoration('National ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'National ID is required';
                      } else if (!RegExp(r'^\d{14}$').hasMatch(value)) {
                        return 'National ID must be 14 digits';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            // Centered image change button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    editedImage = File(picked.path);
                  }
                },
                icon: Icon(Icons.image),
                label: Text("Change Image"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
            const SizedBox(height: 10),

            // Row with Save and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? token = prefs.getString("token");

                      Map<String, String> updatedData = {
                        "Name": nameController.text,
                        "PhoneNumber": phoneController.text,
                        "specialty": specialtyController.text,
                        "Email": emailController.text,
                        "Salary": double.parse(salaryController.text).toString(), // ✅ تحويل مباشر لـ double ثم String
                        "NationalId": nationalIdController.text,
                      };

                      final response = await ApiManager.updateWorker(
                        worker['id'],
                        updatedData,
                        token!,
                        image: editedImage,
                      );

                      if (response != null &&
                          response.message == "Worker updated successfully") {
                        await loadWorkers();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Worker data updated successfully')),
                        );
                      } else {
                        print("Error response: ${response?.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update data')),
                        );
                      }
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Save"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text("Cancel"),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
      appBar: CustomAppBar(title: "Farm Workers",),

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
                            content: const Text(
                                "Are you sure you want to delete this worker?"),
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
                                const SnackBar(
                                    content: Text(
                                        "Authorization token is missing.")),
                              );
                              return;
                            }

                            final deleteResponse =
                                await ApiManager.deleteWorker(
                                    worker.id!, token);

                            if (deleteResponse != null &&
                                deleteResponse.success) {
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
                              SnackBar(
                                  content: Text("Error deleting worker: $e")),
                            );
                          }
                        }
                      },

                      onEdit: () => showEditWorkerDialog(context, {
                        'id': worker.id,
                        'name': worker.name,
                        'phoneNumber': worker.phone,
                        'specialty': worker.specialty,
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
//     'specialty': worker.specialty,
//     'email': worker.email,
//     'salary': worker.salary,
//     'nationalId': worker.nationalID,
//   }),
//   onImagePick: () {},
//   // onDelete: () => _confirmDelete(context, index), // لو في دالة للحذف
//   // onEdit: () => _showAddWorkerDialog(context, index), // لو في دالة للتعديل
//   // onImagePick: () => _pickImage(index), // لو في دالة لاختيار صورة
// );
