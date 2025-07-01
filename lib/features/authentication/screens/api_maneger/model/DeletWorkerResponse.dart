// class DeleteWorkerResponse {
//   final bool success;
//   final String message;
//
//   DeleteWorkerResponse({required this.success, required this.message});
//
//   factory DeleteWorkerResponse.fromJson(Map<String, dynamic> json) {
//     return DeleteWorkerResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//     );
//   }
// }

class DeleteWorkerResponse {
  final bool success;
  final String message;

  DeleteWorkerResponse({required this.success, required this.message});

  factory DeleteWorkerResponse.fromJson(Map<String, dynamic> json) {
    // نخلي النجاح يعتمد على الرسالة بدل وجود مفتاح success
    final message = json['message'] ?? '';
    final success = message.toLowerCase().contains('success');
    return DeleteWorkerResponse(success: success, message: message);
  }
}
