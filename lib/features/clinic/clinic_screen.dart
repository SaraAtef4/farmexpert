import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicScreen extends StatelessWidget {
  final Uri clinicUrl = Uri.parse(
      'https://3edc-156-197-246-205.ngrok-free.app/');

  Future<void> _launchClinicWebsite() async {
    if (!await launchUrl(clinicUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $clinicUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Vet Clinic',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.pets, color: Colors.green.shade800),
                SizedBox(width: 10),
                Text(
                  'Our Veterinary Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),

          //  SizedBox(height: 16),

          ClinicCard(
            title: 'Diagnosis Service',
            icon: Icons.medical_services,
            description: 'Get quick health assessments for your animals.',
          ),

          ClinicCard(
            title: 'Skin Disease Detection',
            icon: Icons.healing,
            description: 'Detect and understand skin conditions easily.',
          ),

          ClinicCard(
            title: 'Drug Interaction Checker',
            icon: Icons.medication_outlined,
            description: 'Check if two drugs can be used together safely.',
          ),

          SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: _launchClinicWebsite,
            icon: Icon(Icons.open_in_new),
            label: Text('Go to Clinic Website'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ClinicCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.green),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}