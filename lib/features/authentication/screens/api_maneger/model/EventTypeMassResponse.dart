class EventTypeMassResponse {
  final String name;

  EventTypeMassResponse({required this.name});

  factory EventTypeMassResponse.fromJson(String value) {
    return EventTypeMassResponse(name: value);
  }
}
