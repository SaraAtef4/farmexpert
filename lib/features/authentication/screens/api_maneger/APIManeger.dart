// // import 'dart:convert';
// // import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';
// // import 'package:http/http.dart' as http;
// //
// // class ApiManager {
// //   final String baseUrl = "http://farmxpertapi.runasp.net/api/Auth/login";
// //
// //   // دالة تسجيل الدخول
// //   Future<AuthServiceResponse?> loginUser(String email, String password) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(baseUrl),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"email": email, "password": password}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         return AuthServiceResponse.fromJson(data);
// //       } else {
// //         return null; // فشل تسجيل الدخول
// //       }
// //     } catch (e) {
// //       print("Error: $e");
// //       return null;
// //     }
// //   }
// //
// //
// // }
//
// import 'dart:convert';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
// import 'package:http/http.dart' as http;
// import 'auth_service_response.dart';
//
// class ApiManager {
//   final String loginUrl = "http://farmxpertapi.runasp.net/api/Auth/login";
//   final String addWorkerUrl = "http://farmxpertapi.runasp.net/api/Worker/AddWorker";
//   final String getAllWorkersUrl = "http://farmxpertapi.runasp.net/api/Worker/all";
//
//   // دالة تسجيل الدخول
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
//       print("Login error: $e");
//       return null;
//     }
//   }
//
//   // دالة إضافة عامل
//   static Future<http.Response> addWorker(
//       Map<String, dynamic> workerData, String token) async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://farmxpertapi.runasp.net/api/Worker/AddWorker"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(workerData),
//       );
//
//       return response; // هنفك الـ JSON برة حسب الحاجة
//     } catch (e) {
//       throw Exception("Failed to add worker: $e");
//     }
//   }
//
//   // دالة جلب جميع العمال
//   static Future<List<GetAllResponse>> getAllWorkers(String token) async {
//     try {
//       print("🔑 Token used in getAllWorkers: $token");
//
//       final response = await http.get(
//         Uri.parse("http://farmxpertapi.runasp.net/api/Worker/all"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("📡 Status Code: ${response.statusCode}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         print("✅ Workers fetched successfully: ${data.length} workers found.");
//         return data.map((item) => GetAllResponse.fromJson(item)).toList();
//       } else {
//         print("❌ Failed to load workers. Response Body: ${response.body}");
//         throw Exception("Failed to load workers: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("🚨 Exception in getAllWorkers: $e");
//       throw Exception("Error getting workers: $e");
//     }
//   }
// }
//
// import 'dart:convert';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddWorkerRespose.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
// import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';
// import 'package:http/http.dart' as http;
//
// class ApiManager {
//   final String loginUrl = "http://farmxpertapi.runasp.net/api/Auth/login";
//   final String addWorkerUrl =
//       "http://farmxpertapi.runasp.net/api/Worker/AddWorker";
//   final String getAllWorkersUrl =
//       "http://farmxpertapi.runasp.net/api/Worker/all";
//
//   // ✅ دالة تسجيل الدخول
//   Future<AuthServiceResponse?> loginUser(String email, String password) async {
//     try {
//       print("🔐 Attempting login with email: $email");
//
//       final response = await http.post(
//         Uri.parse(loginUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );
//
//       print("📥 Login status: ${response.statusCode}");
//       print("📥 Login response: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return AuthServiceResponse.fromJson(data);
//       } else {
//         print("❌ Login failed: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("🚨 Login error: $e");
//       return null;
//     }
//   }
//
//
//   static Future<List<GetAllResponse>> getAllWorkers(String token) async {
//     try {
//       print("🔑 Token used in getAllWorkers: $token");
//
//       final response = await http.get(
//         Uri.parse("http://farmxpertapi.runasp.net/api/Worker/all"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("📡 Status Code: ${response.statusCode}");
//       print("📥 Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         print("✅ Workers fetched successfully: ${data.length} workers found.");
//         return data.map((item) => GetAllResponse.fromJson(item)).toList();
//       } else {
//         print("❌ Failed to load workers. Response Body: ${response.body}");
//         throw Exception("Failed to load workers: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("🚨 Exception in getAllWorkers: $e");
//       throw Exception("Error getting workers: $e");
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/DeletWorkerResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/UpdateWorkerResponse.dart';
import 'package:http/http.dart' as http;
import 'package:farmxpert/features/authentication/screens/api_maneger/model/AddWorkerRespose.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/auth_service_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {
  final String loginUrl = "http://farmxpertapi.runasp.net/api/Auth/login";
  final String addWorkerUrl = "http://farmxpertapi.runasp.net/api/Worker/AddWorker";
  final String getAllWorkersUrl = "http://farmxpertapi.runasp.net/api/Worker/all";

  // ✅ تسجيل الدخول
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


  // ✅ إضافة عامل
  static Future<AddWorkerResponse?> addWorker(Map<String, String> data, String token, {File? image}) async {
    try {
      var uri = Uri.parse("http://farmxpertapi.runasp.net/api/Worker/AddWorker");
      var request = http.MultipartRequest("POST", uri);

      request.headers['Authorization'] = 'Bearer $token';

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('Image', image.path));
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

  static Future<UpdateWorkerResponse?> updateWorker(
      int workerId, Map<String, String> updatedData, String token) async {
    try {
      var url = Uri.parse("http://farmxpertapi.runasp.net/api/Worker/UpdateWorker/$workerId");

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


  // static Future<DeleteWorkerResponse?> deleteWorker(int workerId, String token) async {
  //   final url = Uri.parse('http://farmxpertapi.runasp.net/api/Worker/delete/$workerId');
  //
  //   try {
  //     print("🚨 Sending request with token: $token"); // تحقق من الـ token هنا
  //
  //     final response = await http.delete(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         // 'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     final json = jsonDecode(response.body);
  //     print('🗑️ Delete status: ${response.statusCode}');
  //     print('🗑️ Delete body: $json');
  //
  //     if (response.statusCode == 200) {
  //       return DeleteWorkerResponse.fromJson(json);
  //     } else {
  //       return DeleteWorkerResponse.fromJson(json);
  //     }
  //   } catch (e) {
  //     print('❌ Error deleting worker: $e');
  //     return null;
  //   }
  // }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');

  }

  static Future<DeleteWorkerResponse?> deleteWorker(int workerId) async {
    final token = await getToken(); // جبنا التوكن هنا
    if (token == null) {
      print("❌ No token found");
      return null;
    }

    final url = Uri.parse('http://farmxpertapi.runasp.net/api/Worker/delete/$workerId');

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

}
