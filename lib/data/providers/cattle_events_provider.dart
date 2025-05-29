import 'package:flutter/foundation.dart';
import '../../features/cattle_activity/models/activity_model.dart';

class CattleEventsProvider with ChangeNotifier {
  final List<CattleActivityEvent> _events = [];

  // Filter variables
  String? filterEventType;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  bool? filterIsIndividual;


  List<CattleActivityEvent> get allEvents => List.unmodifiable(_events);

  void addEvent(CattleActivityEvent event) {
    _events.add(event);
    notifyListeners();
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
