class DeleteCattleResponse {
  final String message;

  DeleteCattleResponse({required this.message});

  factory DeleteCattleResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCattleResponse(
      message: json['message'] ?? '',
    );
  }
}
