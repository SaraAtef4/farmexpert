class DeleteEventResponse {
  final String message;

  DeleteEventResponse({required this.message});

  factory DeleteEventResponse.fromJson(Map<String, dynamic> json) {
    return DeleteEventResponse(
      message: json['message'] ?? '',
    );
  }
}
