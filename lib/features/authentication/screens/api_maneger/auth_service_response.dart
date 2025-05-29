class AuthServiceResponse {
  String? token;

  AuthServiceResponse({this.token});

  AuthServiceResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}
