import 'package:farmxpert/features/workers/screens/workers_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/farm_satff_card.dart';
import 'veterian_screen.dart';

class FarmStaffScreen extends StatelessWidget {
  const FarmStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Farm Staff",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 250,
                child: FarmSatffCard(
                  title: "Veterinarians",
                  imagePath: "assets/doctor 1.png",
                  color: Colors.green.shade50,
                  onTap: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VeterianScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                width: 250,
                child: FarmSatffCard(
                  title: "Workers",
                  imagePath: "assets/farmer 1.png",
                  color: Colors.yellow.shade50,
                   onTap: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkersScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
