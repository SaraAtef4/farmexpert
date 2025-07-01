class AddCattleResponse {
  final String? message;
  final int? cattleID;

  AddCattleResponse({this.message, this.cattleID});

  factory AddCattleResponse.fromJson(Map<String, dynamic> json) {
    return AddCattleResponse(
      message: json['message'],
      cattleID: json['cattleID'],
    );
  }
}
