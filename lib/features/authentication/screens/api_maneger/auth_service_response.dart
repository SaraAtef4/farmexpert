

import 'dart:convert';

class AuthServiceResponse {
  String? token;
  String? role;

  AuthServiceResponse({this.token, this.role});

  factory AuthServiceResponse.fromJson(Map<String, dynamic> json) {
    String? token = json['token'];
    String? role;

    if (token != null) {
      // فك تشفير الـ payload من الـ token
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final payloadMap = jsonDecode(payload);
        role = payloadMap["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
      }
    }

    print("✅ Role Extracted: $role");
    return AuthServiceResponse(token: token, role: role);
  }
}
