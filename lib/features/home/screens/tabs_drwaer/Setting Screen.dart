import 'dart:io';
import 'package:farmxpert/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/colors.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? userName;
  String? userEmail;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User Name';
      userEmail = prefs.getString('user_email') ?? 'example@email.com';
      userImage = prefs.getString('user_image') ??
          'assets/images/user_profiel.png'; // تعديل الصورة الافتراضية
    });
  }

  _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userImage = pickedFile.path;
      });
      await prefs.setString('user_image', pickedFile.path);
    }
  }

  _viewProfileInformation() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProfileInformationScreen(
    //       userName: userName,
    //       userEmail: userEmail,
    //       userImage: userImage,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: false,
        title: Text(
          "Setting",
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            iconColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              if (value == 'edit_profile') {
                _showEditBottomSheet();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: userImage != null
                      ? FileImage(File(userImage!))
                      : AssetImage('assets/images/user_profiel.png')
                  as ImageProvider,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userName ?? "User Name",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                userEmail ?? "example@email.com",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              buildSection("Account Settings", [
                // settingItem(Icons.lock, "Change Password", "Change your current password", null),
                settingItem(Icons.lock, "Change Password",
                    "Change your current password", _showPasswordChangeAlert),
              ]),
              buildSection("Notifications Settings", [
                settingItem(Icons.notifications, "Push Notifications",
                    "New contracts Sign or Send", null),
              ]),
              buildSection("General Settings", [
                settingItem(
                    Icons.star, "Rate our App", "Rate & Review Us", null),
                settingItem(Icons.feedback, "Send Feedback",
                    "Share your thought", null),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey.shade300),
          ...items,
        ],
      ),
    );
  }

  Widget settingItem(
      IconData icon, String title, String subtitle, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 22),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle:
      Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
    );
  }

  _showEditBottomSheet() {
    TextEditingController nameController =
    TextEditingController(text: userName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: userImage != null
                      ? FileImage(File(userImage!))
                      : AssetImage('assets/images/user_profiel.png')
                  as ImageProvider,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Enter your new name",
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                style: TextStyle(fontSize: 20, color: Colors.black),
                cursorColor: Colors.green,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        setState(() {
                          userName = nameController.text;
                        });
                        await prefs.setString('user_name', nameController.text);

                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(userType: '',),
                          ),
                        );
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showPasswordChangeAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Change Password",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          content: Text(
            "لتغيير كلمة السر، يرجى التواصل مع الدعم الفني الخاص بالتطبيق.",
            style: TextStyle(fontSize: 18),
            textDirection: TextDirection.rtl,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "حسنا",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }
}
