import 'MilkProductionRecord.dart';

class EditMilkProductionResponse {
  final String message;
  final MilkProductionRecord milk;

  EditMilkProductionResponse({
    required this.message,
    required this.milk,
  });

  factory EditMilkProductionResponse.fromJson(Map<String, dynamic> json) {
    return EditMilkProductionResponse(
      message: json['message'],
      milk: MilkProductionRecord.fromJson(json['milk']),
    );
  }
}
