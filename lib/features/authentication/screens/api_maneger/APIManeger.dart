import 'dart:convert';
import 'dart:io';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddVeterinairsResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeletWorkerResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeleteCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UbdateCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateVeterinairResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateWorkerResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/get_cattle_model_response.dart';
import 'package:http/http.dart' as http;
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddWorkerRespose.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {
  final String loginUrl = "http://farmxpertapi.runasp.net/api/Auth/login";
  final String addWorkerUrl =
      "http://farmxpertapi.runasp.net/api/Worker/AddWorker";
  final String getAllWorkersUrl =
      "http://farmxpertapi.runasp.net/api/Worker/all";

  Future<AuthServiceResponse?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthServiceResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("🚨 Login error: $e");
      return null;
    }
  }

  static Future<List<GetAllResponse>> getAllWorkers(String token) async {
    try {
      final response = await http.get(
        Uri.parse("http://farmxpertapi.runasp.net/api/Worker/all"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // طباعة الاستجابة للتحقق منها
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => GetAllResponse.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load workers: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting workers: $e");
    }
  }

  static Future<List<GetAllResponse>> getAllVeterinairs(String token) async {
    try {
      final response = await http.get(
        Uri.parse("http://farmxpertapi.runasp.net/api/Veterinarians/all"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // طباعة الاستجابة للتحقق منها
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => GetAllResponse.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load Veterinairs: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting Veterinairs: $e");
    }
  }

  // ✅ إضافة عامل
  static Future<AddWorkerResponse?> addWorker(
      Map<String, String> data, String token,
      {File? image}) async {
    try {
      var uri =
          Uri.parse("http://farmxpertapi.runasp.net/api/Worker/AddWorker");
      var request = http.MultipartRequest("POST", uri);

      request.headers['Authorization'] = 'Bearer $token';

      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Image', image.path));
      }

      request.fields.addAll(data);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(respStr);
        return AddWorkerResponse.fromJson(json);
      } else {
        print("❌ Failed to add worker: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error adding worker: $e");
      return null;
    }
  }

  static Future<AddVeterinairsResponse?> addVeterinairs(
      Map<String, String> data, String token,
      {File? image}) async {
    try {
      var uri = Uri.parse(
          "http://farmxpertapi.runasp.net/api/Veterinarians/AddVeterinar");
      var request = http.MultipartRequest("POST", uri);

      request.headers['Authorization'] = 'Bearer $token';

      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Image', image.path));
      }

      request.fields.addAll(data);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(respStr);
        return AddVeterinairsResponse.fromJson(json);
      } else {
        print("❌ Failed to add worker: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error adding worker: $e");
      return null;
    }
  }

  static Future<UpdateWorkerResponse?> updateWorker(
      int workerId, Map<String, String> updatedData, String token) async {
    try {
      var url = Uri.parse(
          "http://farmxpertapi.runasp.net/api/Worker/UpdateWorker/$workerId");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UpdateWorkerResponse.fromJson(json);
      } else {
        print("❌ Failed to update worker: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Error updating worker: $e");
      return null;
    }
  }

  static Future<UpdateVeterinairResponse?> updateVeterinair(
      int veterinairId, Map<String, String> updatedData, String token) async {
    try {
      var url = Uri.parse(
          "http://farmxpertapi.runasp.net/api/Veterinarians/UpdateVeterinar/$veterinairId");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UpdateVeterinairResponse.fromJson(json);
      } else {
        print("❌ Failed to update veterinair: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Error updating veterinair: $e");
      return null;
    }
  }

  static Future<DeleteWorkerResponse?> deleteWorker(
      int workerId, String token) async {
    final url =
        Uri.parse('http://farmxpertapi.runasp.net/api/Worker/delete/$workerId');

    try {
      print("🚨 Sending request with token: $token");

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);
      print('🗑️ Delete status: ${response.statusCode}');
      print('🗑️ Delete body: $json');

      return DeleteWorkerResponse.fromJson(json);
    } catch (e) {
      print('❌ Error deleting worker: $e');
      return null;
    }
  }

///////////////////////Cattle///////////

  static Future<List<CattleModel>> getCattlesByType(String type, String token) async {
    final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/GetCattlesByType/$type");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      print("📡 Response status: ${response.statusCode}");
      print("📡 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => CattleModel.fromJson(json)).toList();
      } else {
        print("❌ Failed to load cattles of type $type: ${response.body}");
        return [];
      }
    } catch (e) {
      print("🚨 Error fetching cattles by type: $e");
      return [];
    }
  }

  static Future<AddCattleResponse?> addCattle(
      Map<String, String> data, String token,
      {File? image}
      ) async {
    try {
      var uri = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/AddCattle");
      var request = http.MultipartRequest("POST", uri);

      request.headers['Authorization'] = 'Bearer $token';

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('Image', image.path));
      }

      request.fields.addAll(data); // Add: Type, Weight, Age, Gender

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(respStr);
        return AddCattleResponse.fromJson(json);
      } else {
        print("❌ Failed to add cattle: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error adding cattle: $e");
      return null;
    }
  }


  static Future<UpdateCattleResponse?> updateCattle(
      int cattleId,
      Map<String, dynamic> updatedData,
      String token,
      ) async {
    try {
      final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/UpdateCattle/$cattleId");

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedData), // ✅ هنا التعديل المهم
      );

      print("🔧 Update Response status: ${response.statusCode}");
      print("🔧 Update Response body: ${response.body}");
      print(updatedData);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UpdateCattleResponse.fromJson(json);
      } else {
        print("❌ Failed to update cattle: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Error updating cattle: $e");
      return null;
    }
  }


  static Future<DeleteCattleResponse?> deleteCattle(
      int cattleId,
      String token,
      ) async {
    try {
      final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/DeleteCattle/$cattleId");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🗑️ Delete Response status: ${response.statusCode}");
      print("🗑️ Delete Response body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DeleteCattleResponse.fromJson(json);
      } else {
        print("❌ Failed to delete cattle: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Error deleting cattle: $e");
      return null;
    }
  }


  static Future<CattleModel?> getCattleByTypeAndId(String type, int id, String token) async {
    try {
      final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/GetCattleByTypeAndId/$type/$id");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🔍 GetByTypeAndId Status: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CattleModel.fromJson(json); // أو استخدم GetCattleByTypeAndIdResponse.fromJson(json);
      } else {
        print("❌ Failed to fetch cattle by ID: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching cattle by ID: $e");
      return null;
    }
  }



}
