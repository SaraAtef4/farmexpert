import 'package:flutter/foundation.dart';
import '../../features/authentication/screens/api_maneger/APIManeger.dart';
import '../../features/authentication/screens/api_maneger/model/AddEventCattleActivityINDResponse.dart';
import '../../features/cattle_activity/models/activity_model.dart';

class CattleEventsProvider with ChangeNotifier {
  final List<CattleActivityEvent> _events = [];

  // Filter variables
  String? filterEventType;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  bool? filterIsIndividual;

  List<String> _eventTypes = [];
  bool _isLoading = false;
  String? _error;

  List<String> get eventTypes => _eventTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEventTypesIND() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiManager().getEventTypesCattleActivityIND();
      if (result != null) {
        _eventTypes = result.eventTypes;
      } else {
        _error = "Failed to load event types";
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
  List<CattleActivityEvent> get allEvents => List.unmodifiable(_events);



  void addEvent(CattleActivityEvent event) {
    _events.add(event);
    notifyListeners();
  }
  void addEventFromResponse(AddEventCattleActivityINDResponse response, bool isIndividual) {
    final event = CattleActivityEvent(
      cattleId: response.eventData.tagNumber,
      eventType: response.eventData.EventType.toString(),
      date: DateTime.parse(response.eventData.date.toString()),
      notes: '',
      isIndividual: isIndividual,
      additionalData: {
        "medicine": response.eventData.medicine,
        "dosage": response.eventData.dosage,
        "withdrawalTime": response.eventData.withdrawalTime,
      }..removeWhere((key, value) => value == null),
    );
    addEvent(event);
  }

  void removeEvent(CattleActivityEvent event) {
    _events.remove(event);
    notifyListeners();
  }

  void deleteEvent(CattleActivityEvent event) {
    _events.remove(event);
    notifyListeners();
  }

  List<CattleActivityEvent> getFilteredEvents({bool? isIndividual}) {
    return _events.where((event) {
      if (isIndividual != null && event.isIndividual != isIndividual) {
        return false;
      }
      if (filterEventType != null && event.eventType != filterEventType) {
        return false;
      }
      if (filterStartDate != null && event.date.isBefore(filterStartDate!)) {
        return false;
      }
      if (filterEndDate != null) {
        DateTime endDateInclusive = filterEndDate!.add(Duration(days: 1));
        if (event.date.isAfter(endDateInclusive)) {
          return false;
        }
      }
      if (filterIsIndividual != null && event.isIndividual != filterIsIndividual) {
        return false;
      }
      return true;
    }).toList();
  }

  void applyFilters({
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
    bool? isIndividual,
  }) {
    filterEventType = eventType;
    filterStartDate = startDate;
    filterEndDate = endDate;
    filterIsIndividual = isIndividual;
    notifyListeners();
  }

  void clearFilters() {
    if (filterEventType != null || filterStartDate != null || filterEndDate != null || filterIsIndividual != null) {
      filterEventType = null;
      filterStartDate = null;
      filterEndDate = null;
      filterIsIndividual = null;
      notifyListeners();
    }
  }

  bool hasActiveFilters() {
    return filterEventType != null ||
        filterStartDate != null ||
        filterEndDate != null ||
        filterIsIndividual != null;
  }

}
