class DeleteMilkProductionResponse {
  final String message;

  DeleteMilkProductionResponse({required this.message});

  factory DeleteMilkProductionResponse.fromJson(Map<String, dynamic> json) {
    return DeleteMilkProductionResponse(
      message: json['message'],
    );
  }
}
