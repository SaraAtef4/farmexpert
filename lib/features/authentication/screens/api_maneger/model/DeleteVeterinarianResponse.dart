class DeleteVeterinarianResponse {
  final bool success;
  final String message;

  DeleteVeterinarianResponse({required this.success, required this.message});

  factory DeleteVeterinarianResponse.fromJson(Map<String, dynamic> json) {
    // نخلي النجاح يعتمد على الرسالة بدل وجود مفتاح success
    final message = json['message'] ?? '';
    final success = message.toLowerCase().contains('success');
    return DeleteVeterinarianResponse(success: success, message: message);
  }
}