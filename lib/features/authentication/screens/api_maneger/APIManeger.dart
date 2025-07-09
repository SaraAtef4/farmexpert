// import 'dart:convert';
// import 'dart:io';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddCattleResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddMilkProductionMultipleResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddMilkProductionResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddVeterinairsResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeletWorkerResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeleteCattleResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetCattlesByTypeAndGender.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/MilkProductionRecord.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/UbdateCattleResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateVeterinairResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateWorkerResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/get_cattle_model_response.dart';
// import 'package:http/http.dart' as http;
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddWorkerRespose.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ApiManager {
//   final String loginUrl = "https://farmxpertapi.runasp.net/api/Auth/login";
//   final String addWorkerUrl =
//       "http://farmxpertapi.runasp.net/api/Worker/AddWorker";
//   final String getAllWorkersUrl =
//       "https://farmxpertapi.runasp.net/api/Worker/all";
//
//   Future<AuthServiceResponse?> loginUser(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(loginUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return AuthServiceResponse.fromJson(data);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Login error: $e");
//       return null;
//     }
//   }
//
//   static Future<List<GetAllResponse>> getAllWorkers(String token) async {
//     try {
//       final response = await http.get(
//         Uri.parse("https://farmxpertapi.runasp.net/api/Worker/all"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Response body: ${response.body}'); // طباعة الاستجابة للتحقق منها
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((item) => GetAllResponse.fromJson(item)).toList();
//       } else {
//         throw Exception("Failed to load workers: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error getting workers: $e");
//     }
//   }
//
//   static Future<List<GetAllResponse>> getAllVeterinairs(String token) async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://farmxpertapi.runasp.net/api/Veterinarians/all"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Response body: ${response.body}'); // طباعة الاستجابة للتحقق منها
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((item) => GetAllResponse.fromJson(item)).toList();
//       } else {
//         throw Exception("Failed to load Veterinairs: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error getting Veterinairs: $e");
//     }
//   }
//
//   // ✅ إضافة عامل
//   static Future<AddWorkerResponse?> addWorker(
//       Map<String, String> data, String token,
//       {File? image}) async {
//     try {
//       var uri =
//           Uri.parse("https://farmxpertapi.runasp.net/api/Worker/AddWorker");
//       var request = http.MultipartRequest("POST", uri);
//
//       request.headers['Authorization'] = 'Bearer $token';
//
//       if (image != null) {
//         request.files
//             .add(await http.MultipartFile.fromPath('Image', image.path));
//       }
//
//       request.fields.addAll(data);
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(respStr);
//         return AddWorkerResponse.fromJson(json);
//       } else {
//         print("❌ Failed to add worker: $respStr");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error adding worker: $e");
//       return null;
//     }
//   }
//
//   static Future<AddVeterinairsResponse?> addVeterinairs(
//       Map<String, String> data, String token,
//       {File? image}) async {
//     try {
//       var uri = Uri.parse(
//           "http://farmxpertapi.runasp.net/api/Veterinarians/AddVeterinar");
//       var request = http.MultipartRequest("POST", uri);
//
//       request.headers['Authorization'] = 'Bearer $token';
//
//       if (image != null) {
//         request.files
//             .add(await http.MultipartFile.fromPath('Image', image.path));
//       }
//
//       request.fields.addAll(data);
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(respStr);
//         return AddVeterinairsResponse.fromJson(json);
//       } else {
//         print("❌ Failed to add worker: $respStr");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error adding worker: $e");
//       return null;
//     }
//   }
//
//
//
//   static Future<UpdateWorkerResponse?> updateWorker(
//       int workerId,
//       Map<String, String> updatedData,
//       String token, {
//         File? image,
//       }) async {
//     try {
//       var uri = Uri.parse(
//           "https://farmxpertapi.runasp.net/api/Worker/UpdateWorker/$workerId");
//
//       var request = http.MultipartRequest("PUT", uri);
//       request.headers['Authorization'] = 'Bearer $token';
//
//       request.fields.addAll(updatedData);
//
//       if (image != null) {
//         request.files.add(await http.MultipartFile.fromPath('ImagePath', image.path));
//       }
//
//       final streamedResponse = await request.send();
//       final responseBody = await streamedResponse.stream.bytesToString();
//
//       print("Response status: ${streamedResponse.statusCode}");
//       print("Response body: $responseBody");
//
//       if (streamedResponse.statusCode == 200) {
//         final json = jsonDecode(responseBody);
//         return UpdateWorkerResponse.fromJson(json);
//       } else {
//         print("❌ Failed to update worker: $responseBody");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error updating worker: $e");
//       return null;
//     }
//   }
//
//
//   static Future<UpdateVeterinairResponse?> updateVeterinair(
//       int veterinairId, Map<String, String> updatedData, String token) async {
//     try {
//       var url = Uri.parse(
//           "http://farmxpertapi.runasp.net/api/Veterinarians/UpdateVeterinar/$veterinairId");
//
//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(updatedData),
//       );
//
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         return UpdateVeterinairResponse.fromJson(json);
//       } else {
//         print("❌ Failed to update veterinair: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error updating veterinair: $e");
//       return null;
//     }
//   }

//   static Future<DeleteWorkerResponse?> deleteWorker(
//       int workerId, String token) async {
//     final url =
//         Uri.parse('http://farmxpertapi.runasp.net/api/Worker/delete/$workerId');
//
//     try {
//       print("🚨 Sending request with token: $token");
//
//       final response = await http.delete(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       final json = jsonDecode(response.body);
//       print('🗑️ Delete status: ${response.statusCode}');
//       print('🗑️ Delete body: $json');
//
//       return DeleteWorkerResponse.fromJson(json);
//     } catch (e) {
//       print('❌ Error deleting worker: $e');
//       return null;
//     }
//   }
//
// ///////////////////////Cattle///////////
//
//   static Future<List<CattleModel>> getCattlesByType(String type, String token) async {
//     final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/GetCattlesByType/$type");
//
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print("📡 Response status: ${response.statusCode}");
//       print("📡 Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//         return jsonList.map((json) => CattleModel.fromJson(json)).toList();
//       } else {
//         print("❌ Failed to load cattles of type $type: ${response.body}");
//         return [];
//       }
//     } catch (e) {
//       print("🚨 Error fetching cattles by type: $e");
//       return [];
//     }
//   }
//
//   static Future<AddCattleResponse?> addCattle(
//       Map<String, String> data, String token,
//       {File? image}
//       ) async {
//     try {
//       var uri = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/AddCattle");
//       var request = http.MultipartRequest("POST", uri);
//
//       request.headers['Authorization'] = 'Bearer $token';
//
//       if (image != null) {
//         request.files.add(await http.MultipartFile.fromPath('Image', image.path));
//       }
//
//       request.fields.addAll(data); // Add: Type, Weight, Age, Gender
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(respStr);
//         return AddCattleResponse.fromJson(json);
//       } else {
//         print("❌ Failed to add cattle: $respStr");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error adding cattle: $e");
//       return null;
//     }
//   }
//
//
//   static Future<UpdateCattleResponse?> updateCattle(
//       int cattleId,
//       Map<String, dynamic> updatedData,
//       String token,
//       ) async {
//     try {
//       final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/UpdateCattle/$cattleId");
//
//       final response = await http.patch(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(updatedData), // ✅ هنا التعديل المهم
//       );
//
//       print("🔧 Update Response status: ${response.statusCode}");
//       print("🔧 Update Response body: ${response.body}");
//       print(updatedData);
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         return UpdateCattleResponse.fromJson(json);
//       } else {
//         print("❌ Failed to update cattle: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error updating cattle: $e");
//       return null;
//     }
//   }
//
//
//   static Future<DeleteCattleResponse?> deleteCattle(
//       int cattleId,
//       String token,
//       ) async {
//     try {
//       final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/DeleteCattle/$cattleId");
//
//       final response = await http.delete(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print("🗑️ Delete Response status: ${response.statusCode}");
//       print("🗑️ Delete Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         return DeleteCattleResponse.fromJson(json);
//       } else {
//         print("❌ Failed to delete cattle: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Error deleting cattle: $e");
//       return null;
//     }
//   }
//
//
//   static Future<CattleModel?> getCattleByTypeAndId(String type, int id, String token) async {
//     try {
//       final url = Uri.parse("http://farmxpertapi.runasp.net/api/Cattle/GetCattleByTypeAndId/$type/$id");
//
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print("🔍 GetByTypeAndId Status: ${response.statusCode}");
//       print("🔍 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         return CattleModel.fromJson(json); // أو استخدم GetCattleByTypeAndIdResponse.fromJson(json);
//       } else {
//         print("❌ Failed to fetch cattle by ID: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Error fetching cattle by ID: $e");
//       return null;
//     }
//   }
//
//
//
//   static const String baseUrl = 'http://farmxpertapi.runasp.net/api/MilkProduction';
//
//   /// ✅ Get all female cows
//   static Future<List<CattleByTypeAndGender>?> getFemaleCows(String token) async {
//     final url = Uri.parse('$baseUrl/GetCattlesByTypeAndGender?type=Cow&gender=Female');
//
//     try {
//       print('🔼 GET female cows: $url');
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print('📥 Status code: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as List;
//         return data.map((json) => CattleByTypeAndGender.fromJson(json)).toList();
//       } else {
//         print('❌ Failed to fetch female cows: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Exception in getFemaleCows: $e');
//       return null;
//     }
//   }
//
//   /// ✅ Add single milk record
//   static Future<AddMilkProductionResponse?> addMilkProductionRecord({
//     required String token,
//     required String tagNumber,
//     required String countNumber,
//     double am = 0,
//     double noon = 0,
//     double pm = 0,
//     required String notes,
//     required String date, // ISO format date string
//   }) async {
//     final url = Uri.parse('$baseUrl/Add');
//     final total = am + noon + pm;
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           "tagNumber": tagNumber,
//           "countNumber": countNumber,
//           "am": am,
//           "noon": noon,
//           "pm": pm,
//           "total": total,
//           "notes": notes,
//           "date": date,
//         }),
//       );
//
//       print('📥 AddMilkProduction status: ${response.statusCode}');
//       print('📥 Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return AddMilkProductionResponse.fromJson(data);
//       } else {
//         print('❌ Error adding milk record: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Exception in addMilkProductionRecord: $e');
//       return null;
//     }
//   }
//
//   /// ✅ Add bulk milk records
//   static Future<AddMilkProductionMultipleResponse?> addMilkProductionBulk({
//     required String token,
//     required String countNumber,
//     double? am,
//     double? noon,
//     double? pm,
//     required double total,
//     required String notes,
//     required String date, // ISO format
//   }) async {
//     final url = Uri.parse('$baseUrl/AddMultiple');
//
//     try {
//       final body = {
//         "countNumber": countNumber,
//         "am": am ?? 0,
//         "noon": noon ?? 0,
//         "pm": pm ?? 0,
//         "total": total,
//         "notes": notes,
//         "date": date,
//       };
//
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(body),
//       );
//
//       print('📥 Bulk Add status: ${response.statusCode}');
//       print('📥 Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return AddMilkProductionMultipleResponse.fromJson(data);
//       } else {
//         print('❌ Bulk Add Failed: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Exception in addMilkProductionBulk: $e');
//       return null;
//     }
//   }
//
//   /// ✅ Get all milk records
//   static Future<List<MilkProductionRecord>?> getAllMilkRecords(String token) async {
//     final url = Uri.parse('$baseUrl/All');
//
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       print('📥 GetAllMilk status: ${response.statusCode}');
//       print('📥 Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final records = data.map((item) => MilkProductionRecord.fromJson(item)).toList();
//
//         double totalSum = records.fold(0, (sum, record) => sum + record.total);
//         print('🧮 Total sum of all milk records: $totalSum');
//
//         return records;
//
//       } else {
//         print('❌ Failed to fetch records: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Exception in getAllMilkRecords: $e');
//       return null;
//     }
//   }
//
//
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddMilkProductionMultipleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddMilkProductionResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddVeterinairsResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeletWorkerResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeleteCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetCattlesByTypeAndGender.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/MilkProductionRecord.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UbdateCattleResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateVeterinairResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateWorkerResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/get_cattle_model_response.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddWorkerRespose.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';

import '../../../cattle_activity/models/activity_model.dart';
import 'constants.dart';
import 'model/AddEventCattleActivityINDResponse.dart';
import 'model/AddEventCattleActivityMassResponse.dart';
import 'model/AllEventsResponse.dart';
import 'model/AllMassEventResponse.dart';
import 'model/DeleteEventResponse.dart';
import 'model/DeleteMilkProductionResponse.dart';
import 'model/DeleteVeterinarianResponse.dart';
import 'model/EditMilkProductionResponse.dart';
import 'model/EventTypeMassResponse.dart';
import 'model/EventTypeResponseCattleActivityIND.dart';

class ApiManager {
  Future<AuthServiceResponse?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
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
        Uri.parse(ApiConstants.getAllWorkers),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
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
        Uri.parse(ApiConstants.getAllVeterinairs),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => GetAllResponse.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load Veterinairs: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting Veterinairs: $e");
    }
  }

  static Future<AddWorkerResponse?> addWorker(
      Map<String, String> data, String token,
      {File? image}) async {
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiConstants.addWorker));
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
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiConstants.addVeterinair));
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
        print("❌ Failed to add veterinair: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error adding veterinair: $e");
      return null;
    }
  }

  static Future<UpdateWorkerResponse?> updateWorker(
      int workerId, Map<String, String> updatedData, String token,
      {File? image}) async {
    try {
      var request = http.MultipartRequest(
          "PUT", Uri.parse("${ApiConstants.updateWorker}/$workerId"));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(updatedData);
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('ImagePath', image.path));
      }
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final json = jsonDecode(respStr);
        return UpdateWorkerResponse.fromJson(json);
      } else {
        print("❌ Failed to update worker: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error updating worker: $e");
      return null;
    }
  }

  static Future<UpdateVeterinairResponse?> updateVeterinair(
      int veterinairId, Map<String, String> updatedData, String token,
      {File? image}) async {
    try {
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("${ApiConstants.updateVeterinair}/$veterinairId"),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(updatedData);

      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('ImagePath', image.path));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(respStr);
        return UpdateVeterinairResponse.fromJson(json);
      } else {
        print("❌ Failed to update veterinair: $respStr");
        return null;
      }
    } catch (e) {
      print("🚨 Error updating veterinair: $e");
      return null;
    }
  }

  static Future<DeleteWorkerResponse?> deleteWorker(
      int workerId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConstants.deleteWorker}/$workerId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final json = jsonDecode(response.body);
      return DeleteWorkerResponse.fromJson(json);
    } catch (e) {
      print('❌ Error deleting worker: $e');
      return null;
    }
  }

  static Future<DeleteVeterinarianResponse?> deleteVeterinair(
      int veterinairId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConstants.deleteVeterinair}/$veterinairId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);
      return DeleteVeterinarianResponse.fromJson(json);
    } catch (e) {
      print('❌ Error deleting veterinarian: $e');
      return null;
    }
  }

  ////////////////////////////cattle//////////////////////

  static Future<List<CattleModel>> getCattlesByType(
      String type, String token) async {
    final url = Uri.parse("${ApiConstants.getCattlesByType}/$type");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      print("📡 Response status: \${response.statusCode}");
      print("📡 Response body: \${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => CattleModel.fromJson(json)).toList();
      } else {
        print("❌ Failed to load cattles of type \$type: \${response.body}");
        return [];
      }
    } catch (e) {
      print("🚨 Error fetching cattles by type: \$e");
      return [];
    }
  }

  static Future<AddCattleResponse?> addCattle(
      Map<String, String> data, String token,
      {File? image}) async {
    try {
      var uri = Uri.parse(ApiConstants.addCattle);
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
      int cattleId, Map<String, dynamic> updatedData, String token) async {
    try {
      final url = Uri.parse("${ApiConstants.updateCattle}/$cattleId");

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedData),
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
      int cattleId, String token) async {
    try {
      final url = Uri.parse("${ApiConstants.deleteCattle}/$cattleId");

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

  static Future<CattleModel?> getCattleByTypeAndId(
      String type, int id, String token) async {
    try {
      final url = Uri.parse("${ApiConstants.getCattleByTypeAndId}/$type/$id");

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
        return CattleModel.fromJson(json);
      } else {
        print("❌ Failed to fetch cattle by ID: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching cattle by ID: $e");
      return null;
    }
  }

  /////////////////////////milk production////////////////////

  static Future<List<CattleByTypeAndGender>?> getFemaleCows(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getFemaleCows),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data
            .map((json) => CattleByTypeAndGender.fromJson(json))
            .toList();
      } else {
        print('❌ Failed to fetch female cows: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in getFemaleCows: $e');
      return null;
    }
  }

  static Future<AddMilkProductionResponse?> addMilkProductionRecord({
    required String token,
    required String tagNumber,
    required String countNumber,
    double am = 0,
    double noon = 0,
    double pm = 0,
    required String notes,
    required String date,
  }) async {
    final total = am + noon + pm;
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addMilk),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "tagNumber": tagNumber,
          "countNumber": countNumber,
          "am": am,
          "noon": noon,
          "pm": pm,
          "total": total,
          "notes": notes,
          "date": date,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AddMilkProductionResponse.fromJson(data);
      } else {
        print('❌ Error adding milk record: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in addMilkProductionRecord: $e');
      return null;
    }
  }

  static Future<AddMilkProductionMultipleResponse?> addMilkProductionBulk({
    required String token,
    required String countNumber,
    double? am,
    double? noon,
    double? pm,
    required double total,
    required String notes,
    required String date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.addMilkMultiple),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "countNumber": countNumber,
          "am": am ?? 0,
          "noon": noon ?? 0,
          "pm": pm ?? 0,
          "total": total,
          "notes": notes,
          "date": date,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AddMilkProductionMultipleResponse.fromJson(data);
      } else {
        print('❌ Bulk Add Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in addMilkProductionBulk: $e');
      return null;
    }
  }

  static Future<List<MilkProductionRecord>?> getAllMilkRecords(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getAllMilk),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => MilkProductionRecord.fromJson(item)).toList();
      } else {
        print('❌ Failed to fetch records: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in getAllMilkRecords: $e');
      return null;
    }
  }

  static Future<DeleteMilkProductionResponse?> deleteMilkProduction(
      int id, String token) async {
    try {
      final url = Uri.parse('${ApiConstants.deleteMilkProduction}/$id');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DeleteMilkProductionResponse.fromJson(json);
      } else {
        print("❌ Failed to delete milk production: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Error deleting milk production: $e");
      return null;
    }
  }


  static Future<EditMilkProductionResponse?> editMilkProductionRecord({
    required int id,
    required String token,
    required String tagNumber,
    required String countNumber,
    required double am,
    required double noon,
    required double pm,
    required double total,
    required String notes,
    required String date,
  }) async {
    final url = Uri.parse('${ApiConstants.editMilkProduction}/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'tagNumber': tagNumber,
        'countNumber': countNumber,
        'am': am,
        'noon': noon,
        'pm': pm,
        'total': total,
        'notes': notes,
        'date': date,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return EditMilkProductionResponse.fromJson(decoded);
    } else {
      print('❌ Failed to edit milk record: ${response.statusCode}');
      return null;
    }
  }


  /////////////////cattleactivity///////////

   Future<EventTypeResponseCattleActivityIND?> getEventTypesCattleActivityIND() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found in SharedPreferences");
        return null;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.cattleActivityIND_EventTypes),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return EventTypeResponseCattleActivityIND.fromJson(data);
      } else {
        print("⚠️ Error fetching event types: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in getEventTypesCattleActivityIND: $e");
      return null;
    }
  }

  Future<AddEventCattleActivityINDResponse?> addEventCattleActivityIND(Map<String, String> bodyData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found in SharedPreferences");
        return null;
      }

      var uri = Uri.parse(ApiConstants.cattleActivityIND_AddEvent);
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      // 🔒 Clean and add fields (to prevent null crash)
      final cleanedBodyData = <String, String>{};
      bodyData.forEach((key, value) {
        if (key != null && value != null) {
          cleanedBodyData[key] = value;
        }
      });

      request.fields.addAll(cleanedBodyData);

      print("🟡 Final BodyData Sent (Multipart): ${request.fields}");

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        return AddEventCattleActivityINDResponse.fromJson(jsonData);
      } else {
        print("⚠️ Failed to add event: ${response.statusCode}");
        print("❌ Body: $responseBody");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in addEventCattleActivityIND: $e");
      return null;
    }
  }

  static Future<List<CattleModel>> getCowsOnly() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("🚨 Token not found");
      return [];
    }

    final url = Uri.parse("${ApiConstants.getCattlesByType}/Cow");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => CattleModel.fromJson(json)).toList();
      } else {
        print("❌ Failed to load cows: ${response.body}");
        return [];
      }
    } catch (e) {
      print("🚨 Error fetching cows: $e");
      return [];
    }
  }

  Future<List<AllEventsResponse>?> getAllEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found ");
        return null;
      }

      final url = Uri.parse(ApiConstants.cattleActivityIND_AllEvents);
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((e) => AllEventsResponse.fromJson(e)).toList();
      } else {
        print("⚠️ Failed to fetch events: ${response.statusCode}");
        print("❌ Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in getAllEvents: $e");
      return null;
    }
  }

  Future<DeleteEventResponse?> deleteEvent(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found");
        return null;
      }

      final url = '${ApiConstants.cattleActivityIND_DeleteEvent}/$id';
      final uri = Uri.parse(url);

      final response = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeleteEventResponse.fromJson(data);
      } else {
        print("⚠️ Failed to delete event: ${response.statusCode}");
        print(response.body);
        return null;
      }
    } catch (e) {
      print("🚨 Exception in deleteEvent: $e");
      return null;
    }
  }

  Future<List<EventTypeMassResponse>?> fetchMassEventTypes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found in SharedPreferences");
        return null;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.getMassEventTypesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => EventTypeMassResponse.fromJson(e)).toList();
      } else {
        print("⚠️ Error fetching mass event types: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in fetchMassEventTypes: $e");
      return null;
    }
  }

  Future<List<MassEventResponse>?> fetchAllMassEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found in SharedPreferences");
        return null;
      }

      final response = await http.get(
        Uri.parse(ApiConstants.getAllMassEventsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MassEventResponse.fromJson(e)).toList();
      } else {
        print("⚠️ Error fetching mass events: ${response.statusCode}");
        print("Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in fetchAllMassEvents: $e");
      return null;
    }
  }

  Future<AddEventCattleActivityMassResponse?> addEventCattleActivityMass(Map<String, String> bodyData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("🚫 No token found in SharedPreferences");
        return null;
      }

      var uri = Uri.parse(ApiConstants.cattleActivityMass_AddEvent); // ✅ الخطوة الجاية هنضيفه في constants
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      // Add cleaned fields (to avoid null crashes)
      final cleanedBodyData = <String, String>{};
      bodyData.forEach((key, value) {
        if (key != null && value != null) {
          cleanedBodyData[key] = value;
        }
      });

      request.fields.addAll(cleanedBodyData);

      print("🟡 Final Mass BodyData Sent (Multipart): ${request.fields}");

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        return AddEventCattleActivityMassResponse.fromJson(jsonData);
      } else {
        print("⚠️ Failed to add mass event: ${response.statusCode}");
        print("❌ Body: $responseBody");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in addEventCattleActivityMass: $e");
      return null;
    }
  }



}
