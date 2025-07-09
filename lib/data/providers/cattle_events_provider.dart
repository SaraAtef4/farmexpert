// import 'package:flutter/foundation.dart';
// import '../../features/authentication/screens/api_maneger/APIManeger.dart';
// import '../../features/authentication/screens/api_maneger/model/AddEventCattleActivityINDResponse.dart';
// import '../../features/cattle_activity/models/activity_model.dart';
//
// class CattleEventsProvider with ChangeNotifier {
//   final List<CattleActivityEvent> _events = [];
//
//   // Filter variables
//   String? filterEventType;
//   DateTime? filterStartDate;
//   DateTime? filterEndDate;
//   bool? filterIsIndividual;
//
//   List<String> _eventTypes = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<String> get eventTypes => _eventTypes;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> fetchEventTypesIND() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final result = await ApiManager().getEventTypesCattleActivityIND();
//       if (result != null) {
//         _eventTypes = result.eventTypes;
//       } else {
//         _error = "Failed to load event types";
//       }
//     } catch (e) {
//       _error = e.toString();
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//   List<CattleActivityEvent> get allEvents => List.unmodifiable(_events);
//
//
//
//   void addEvent(CattleActivityEvent event) {
//     _events.add(event);
//     notifyListeners();
//   }
//   void addEventFromResponse(AddEventCattleActivityINDResponse response, bool isIndividual) {
//     final event = CattleActivityEvent(
//       cattleId: response.eventData.tagNumber,
//       eventType: response.eventData.EventType.toString(),
//       date: DateTime.parse(response.eventData.date.toString()),
//       notes: '',
//       isIndividual: isIndividual,
//       additionalData: {
//         "medicine": response.eventData.medicine,
//         "dosage": response.eventData.dosage,
//         "withdrawalTime": response.eventData.withdrawalTime,
//       }..removeWhere((key, value) => value == null),
//     );
//     addEvent(event);
//   }
//
//   Future<void> fetchAllEventsFromApi() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await ApiManager().getAllEvents();
//       if (response != null) {
//         _events.clear(); // تفريغ القديم
//         for (var eventData in response) {
//           _events.add(
//             CattleActivityEvent(
//               cattleId: eventData.tagNumber,
//               eventType: eventData.eventType,
//               date: DateTime.parse(eventData.date),
//               notes: eventData.notes ?? '',
//               isIndividual: true, // أو تحط شرط حسب نوع الحدث لو هتدعمه
//               additionalData: {
//                 if (eventData.weight != null) "weight": eventData.weight.toString(),
//                 if (eventData.medicine != null) "medicine": eventData.medicine!,
//                 if (eventData.dosage != null) "dosage": eventData.dosage!,
//                 if (eventData.withdrawalTime != null) "withdrawalTime": eventData.withdrawalTime!,
//                 if (eventData.calfGender != null) "calfGender": eventData.calfGender!,
//               },
//             ),
//           );
//         }
//       } else {
//         _error = "Failed to fetch events";
//       }
//     } catch (e) {
//       _error = e.toString();
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   void removeEvent(CattleActivityEvent event) {
//     _events.remove(event);
//     notifyListeners();
//   }
//
//   void deleteEvent(CattleActivityEvent event) {
//     _events.remove(event);
//     notifyListeners();
//   }
//
//   List<CattleActivityEvent> getFilteredEvents({bool? isIndividual}) {
//     return _events.where((event) {
//       if (isIndividual != null && event.isIndividual != isIndividual) {
//         return false;
//       }
//       if (filterEventType != null && event.eventType != filterEventType) {
//         return false;
//       }
//       if (filterStartDate != null && event.date.isBefore(filterStartDate!)) {
//         return false;
//       }
//       if (filterEndDate != null) {
//         DateTime endDateInclusive = filterEndDate!.add(Duration(days: 1));
//         if (event.date.isAfter(endDateInclusive)) {
//           return false;
//         }
//       }
//       if (filterIsIndividual != null && event.isIndividual != filterIsIndividual) {
//         return false;
//       }
//       return true;
//     }).toList();
//   }
//
//   void applyFilters({
//     String? eventType,
//     DateTime? startDate,
//     DateTime? endDate,
//     bool? isIndividual,
//   }) {
//     filterEventType = eventType;
//     filterStartDate = startDate;
//     filterEndDate = endDate;
//     filterIsIndividual = isIndividual;
//     notifyListeners();
//   }
//
//   void clearFilters() {
//     if (filterEventType != null || filterStartDate != null || filterEndDate != null || filterIsIndividual != null) {
//       filterEventType = null;
//       filterStartDate = null;
//       filterEndDate = null;
//       filterIsIndividual = null;
//       notifyListeners();
//     }
//   }
//
//   bool hasActiveFilters() {
//     return filterEventType != null ||
//         filterStartDate != null ||
//         filterEndDate != null ||
//         filterIsIndividual != null;
//   }
//
// }

import 'package:flutter/foundation.dart';
import '../../features/authentication/screens/api_maneger/APIManeger.dart';
import '../../features/authentication/screens/api_maneger/model/AllEventsResponse.dart';
import '../../features/authentication/screens/api_maneger/model/AddEventCattleActivityINDResponse.dart';
import '../../features/authentication/screens/api_maneger/model/AllMassEventResponse.dart';

class CattleEventsProvider with ChangeNotifier {
  List<AllEventsResponse> _events = [];
  List<String> _eventTypes = [];

  List<MassEventResponse> _massEvents = [];

  List<MassEventResponse> get allMassEvents => List.unmodifiable(_massEvents);


  // Filters
  String? filterEventType;
  DateTime? filterStartDate;
  DateTime? filterEndDate;

  bool _isLoading = false;
  String? _error;

  // ✅ Getters
  List<AllEventsResponse> get allEvents => List.unmodifiable(_events);
  List<String> get eventTypes => _eventTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ✅ Fetch all events from API
  Future<void> fetchAllEventsFromApi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager().getAllEvents();
      if (response != null) {
        _events = response;
      } else {
        _error = "Failed to fetch events";
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Fetch event types from API
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

  Future<void> fetchAllMassEventsFromApi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiManager().fetchAllMassEvents();
      if (response != null) {
        _massEvents = response;
      } else {
        _error = "Failed to fetch mass events";
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }


  // ✅ Add new event from response
  void addEventFromResponse(AddEventCattleActivityINDResponse response) {
    final eventData = response.eventData;

    final newEvent = AllEventsResponse(
      id: eventData.id ?? 0,
      eventType: eventData.EventType ?? 'Unknown',
      tagNumber: eventData.tagNumber ?? 0,
      medicine: eventData.medicine,
      dosage: eventData.dosage,
      withdrawalTime: eventData.withdrawalTime,
      notes: '', // Update if needed
      calfGender: null,
      weight: null,
      date: eventData.date ?? DateTime.now().toIso8601String(),
    );

    _events.add(newEvent);
    notifyListeners();
  }

  // ✅ Delete event
  Future<void> deleteEventFromApi(int id) async {
    final result = await ApiManager().deleteEvent(id);
    if (result != null) {
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  // ✅ Get filtered events
  List<AllEventsResponse> getFilteredEvents() {
    return _events.where((event) {
      final eventDate = DateTime.tryParse(event.date);
      if (eventDate == null) return false;

      if (filterEventType != null && event.eventType != filterEventType) return false;
      if (filterStartDate != null && eventDate.isBefore(filterStartDate!)) return false;
      if (filterEndDate != null) {
        final inclusiveEnd = filterEndDate!.add(const Duration(days: 1));
        if (eventDate.isAfter(inclusiveEnd)) return false;
      }

      return true;
    }).toList();
  }

  List<AllEventsResponse> getFilteredMassEvents() {
    return _massEvents
        .where((event) {
      final eventDate = DateTime.tryParse(event.date ?? '');
      if (eventDate == null) return false;

      if (filterEventType != null && event.eventType != filterEventType) return false;
      if (filterStartDate != null && eventDate.isBefore(filterStartDate!)) return false;
      if (filterEndDate != null) {
        final inclusiveEnd = filterEndDate!.add(const Duration(days: 1));
        if (eventDate.isAfter(inclusiveEnd)) return false;
      }

      return true;
    })
        .map((mass) => AllEventsResponse(
      id: mass.id ?? 0,
      eventType: mass.eventType ?? 'Unknown',
      tagNumber: 0,
      medicine: mass.medicine,
      dosage: mass.dosage,
      // withdrawalTime: mass.,
      notes: mass.notes,
      calfGender: null,
      weight: null,
      date: mass.date ?? '',
    ))
        .toList();
  }


  // ✅ Apply filters
  void applyFilters({
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    filterEventType = eventType;
    filterStartDate = startDate;
    filterEndDate = endDate;
    notifyListeners();
  }

  // ✅ Clear filters
  void clearFilters() {
    if (filterEventType != null || filterStartDate != null || filterEndDate != null) {
      filterEventType = null;
      filterStartDate = null;
      filterEndDate = null;
      notifyListeners();
    }
  }

  // ✅ Check if filters are active
  bool hasActiveFilters() {
    return filterEventType != null ||
        filterStartDate != null ||
        filterEndDate != null;
  }
}

