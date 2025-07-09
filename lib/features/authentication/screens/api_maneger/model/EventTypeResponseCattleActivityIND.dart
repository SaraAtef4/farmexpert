class EventTypeResponseCattleActivityIND {
  final List<String> eventTypes;

  EventTypeResponseCattleActivityIND({required this.eventTypes});

  factory EventTypeResponseCattleActivityIND.fromJson(List<dynamic> json) {
    return EventTypeResponseCattleActivityIND(
      eventTypes: List<String>.from(json),
    );
  }
}
