class UpdateCattleResponse {
  final String? message;

  UpdateCattleResponse({this.message});

  factory UpdateCattleResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCattleResponse(
      message: json['message'],
    );
  }
}
