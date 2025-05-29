import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VeterinarianProvider with ChangeNotifier {
  List<Map<String, dynamic>> veterinarians = [];
  List<Map<String, dynamic>> filteredVeterinarians = [];

  VeterinarianProvider() {
    loadVeterinarians();
  }

  Future<void> loadVeterinarians() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? vetsJson = prefs.getString('veterinarians');

      if (vetsJson != null) {
        veterinarians = List<Map<String, dynamic>>.from(json.decode(vetsJson));
        filteredVeterinarians = List.from(veterinarians);
      } else {
        veterinarians = [
          {
            "name": "Dr. Ahmed Alaa",
            "specialty": "Nutrition",
            "phone": "0123456789",
            "salary": 5000,
            "age": 27,
            "nationalId": "12345678901234",
            "code": "VET001",
            "image": null,
            "rating": 4.5,
            "hireDate": DateTime.now().toString(),
            "experienceYears": 5,
          },
        ];
        filteredVeterinarians = List.from(veterinarians);
        await saveVeterinarians();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading veterinarians: $e');
    }
  }

  Future<void> saveVeterinarians() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('veterinarians', json.encode(veterinarians));
    } catch (e) {
      print('Error saving veterinarians: $e');
      throw e;
    }
  }

  void sortByName() {
    veterinarians.sort((a, b) {
      final nameA = a["name"].toString().toLowerCase();
      final nameB = b["name"].toString().toLowerCase();
      return nameA.compareTo(nameB);
    });
    filteredVeterinarians = List.from(veterinarians);
    notifyListeners();
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredVeterinarians = List.from(veterinarians);
    } else {
      filteredVeterinarians =
          veterinarians.where((vet) {
            final name = vet["name"].toString().toLowerCase();
            final specialty = vet["specialty"].toString().toLowerCase();
            final nationalId = vet["nationalId"].toString().toLowerCase();
            final code = vet["code"].toString().toLowerCase();
            final searchLower = query.toLowerCase();

            return name.contains(searchLower) ||
                specialty.contains(searchLower) ||
                nationalId.contains(searchLower) ||
                code.contains(searchLower);
          }).toList();
    }
    notifyListeners();
  }

  void deleteVeterinarian(int index, BuildContext context) {
    veterinarians.removeWhere(
      (vet) => vet["name"] == filteredVeterinarians[index]["name"],
    );
    filteredVeterinarians.removeAt(index);
    saveVeterinarians();
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veterinarian deleted successfully")),
    );
  }

  void addVeterinarian(Map<String, dynamic> newVet, BuildContext context) {
    bool isDuplicate = veterinarians.any(
      (vet) => vet["code"] == newVet["code"],
    );
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veterinarian code already exists")),
      );
      return;
    }

    veterinarians.add({
      ...newVet,
      "hireDate": newVet["hireDate"] ?? DateTime.now().toString(),
      "experienceYears": newVet["experienceYears"] ?? 0,
    });
    filterSearch("");
    saveVeterinarians();
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veterinarian added successfully")),
    );
  }

  void updateVeterinarian(
    int index,
    Map<String, dynamic> updatedVet,
    BuildContext context,
  ) {
    if (veterinarians[index]["code"] != updatedVet["code"]) {
      bool isDuplicate = veterinarians
          .where((vet) => vet != veterinarians[index])
          .any((vet) => vet["code"] == updatedVet["code"]);

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This code is already in use")),
        );
        return;
      }
    }

    veterinarians[index] = {
      ...updatedVet,
      "hireDate": updatedVet["hireDate"] ?? veterinarians[index]["hireDate"],
      "experienceYears":
          updatedVet["experienceYears"] ??
          veterinarians[index]["experienceYears"],
    };
    filterSearch("");
    saveVeterinarians();
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veterinarian updated successfully")),
    );
  }
}

class WorkerProvider with ChangeNotifier {
  List<Map<String, dynamic>> workers = [];
  List<Map<String, dynamic>> filteredWorkers = [];

  WorkerProvider() {
    loadWorkers();
  }

  Future<void> loadWorkers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? workersJson = prefs.getString('workers');

      if (workersJson != null) {
        workers = List<Map<String, dynamic>>.from(json.decode(workersJson));
        filteredWorkers = List.from(workers);
      } else {
        workers = [
          {
            "name": "Ibrahim Salah",
            "specialty": "Warehouse Manager",
            "phone": "0123456789",
            "salary": 3000,
            "age": 28,
            "nationalId": "12345678901234",
            "code": "WRK001",
            "image": null,
            "rating": 3.8,
            "hireDate": DateTime.now().toString(),
            "experienceYears": 3,
          },
        ];
        filteredWorkers = List.from(workers);
        await saveWorkers();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading workers: $e');
    }
  }

  Future<void> saveWorkers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('workers', json.encode(workers));
    } catch (e) {
      print('Error saving workers: $e');
      throw e;
    }
  }

  void sortByName() {
    workers.sort((a, b) {
      final nameA = a["name"].toString().toLowerCase();
      final nameB = b["name"].toString().toLowerCase();
      return nameA.compareTo(nameB);
    });
    filteredWorkers = List.from(workers);
    notifyListeners();
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredWorkers = List.from(workers);
    } else {
      filteredWorkers =
          workers.where((worker) {
            final name = worker["name"].toString().toLowerCase();
            final specialty = worker["specialty"].toString().toLowerCase();
            final nationalId = worker["nationalId"].toString().toLowerCase();
            final code = worker["code"].toString().toLowerCase();
            final searchLower = query.toLowerCase();

            return name.contains(searchLower) ||
                specialty.contains(searchLower) ||
                nationalId.contains(searchLower) ||
                code.contains(searchLower);
          }).toList();
    }
    notifyListeners();
  }

  void deleteWorker(int index, BuildContext context) {
    workers.removeWhere(
      (worker) => worker["name"] == filteredWorkers[index]["name"],
    );
    filteredWorkers.removeAt(index);
    saveWorkers();
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Worker deleted successfully")),
    );
  }

  void addWorker(Map<String, dynamic> newWorker, BuildContext context) {
    bool isDuplicate = workers.any(
      (worker) => worker["code"] == newWorker["code"],
    );
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Worker code already exists")),
      );
      return;
    }

    workers.add({
      ...newWorker,
      "hireDate": newWorker["hireDate"] ?? DateTime.now().toString(),
      "experienceYears": newWorker["experienceYears"] ?? 0,
    });
    filterSearch("");
    saveWorkers();
    notifyListeners();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Worker added successfully")));
  }

  void updateWorker(
    int index,
    Map<String, dynamic> updatedWorker,
    BuildContext context,
  ) {
    if (workers[index]["code"] != updatedWorker["code"]) {
      bool isDuplicate = workers
          .where((worker) => worker != workers[index])
          .any((worker) => worker["code"] == updatedWorker["code"]);

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This code is already in use")),
        );
        return;
      }
    }

    workers[index] = {
      ...updatedWorker,
      "hireDate": updatedWorker["hireDate"] ?? workers[index]["hireDate"],
      "experienceYears":
          updatedWorker["experienceYears"] ?? workers[index]["experienceYears"],
    };
    filterSearch("");
    saveWorkers();
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Worker updated successfully")),
    );
  }
}





