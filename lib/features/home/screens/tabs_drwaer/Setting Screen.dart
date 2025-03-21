import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/image_user.png'), // ضع صورتك هنا
              ),
              const SizedBox(height: 10),
              Text(
                "Kariem Amr",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "kariemamr9999@gmail.com",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              buildSection("Account Settings", [
                settingItem(Icons.person, "Profile Information", "Name, Email, Security"),
                settingItem(Icons.privacy_tip, "Privacy", "Control your privacy"),
                settingItem(Icons.lock, "Change Password", "Change your current password"),
              ]),

              buildSection("Notifications Settings", [
                settingItem(Icons.notifications, "Push Notifications", "New contracts Sign or Send"),
              ]),

              buildSection("General Settings", [
                settingItem(Icons.star, "Rate our App", "Rate & Review Us"),
                settingItem(Icons.feedback, "Send Feedback", "Share your thought"),
                settingItem(Icons.lock, "Send Feedback", "Share your thought"),
                settingItem(Icons.attach_money, "Default Currency", "USD (\$)"),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey.shade300),
          ...items,
        ],
      ),
    );
  }

  Widget settingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 22),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: () {
        // يمكنك إضافة التنقل إلى صفحات أخرى هنا
      },
    );
  }
}