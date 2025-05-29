class DeleteWorkerResponse {
  final bool success;
  final String message;

  DeleteWorkerResponse({required this.success, required this.message});

  factory DeleteWorkerResponse.fromJson(Map<String, dynamic> json) {
    return DeleteWorkerResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
