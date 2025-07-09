//
// import '../models/milk_entry_model.dart';
//
// class MilkFilterService {
//   List<MilkEntryModel> getFilteredAndSortedEntries(
//       List<MilkEntryModel> entries,
//       String sortType,
//       String filterPeriod,
//       DateTime? startDate,
//       DateTime? endDate,
//       ) {
//     List<MilkEntryModel> filtered = List.from(entries);
//
//     if (filterPeriod != 'all') {
//       filtered = _applyDateFilter(
//           filtered,
//           filterPeriod,
//           startDate,
//           endDate
//       );
//     }
//
//     _applySorting(filtered, sortType);
//
//     return filtered;
//   }
//
//
//
//   List<MilkEntryModel> _applyDateFilter(
//       List<MilkEntryModel> entries,
//       String filterPeriod,
//       DateTime? startDate,
//       DateTime? endDate,
//       ) {
//     DateTime now = DateTime.now();
//     DateTime? filterStartDate;
//
//     switch (filterPeriod) {
//       case 'week':
//         filterStartDate = now.subtract(Duration(days: 7));
//         break;
//       case 'month':
//         filterStartDate = DateTime(now.year, now.month - 1, now.day);
//         break;
//       case 'halfYear':
//         filterStartDate = DateTime(now.year, now.month - 6, now.day);
//         break;
//       case 'year':
//         filterStartDate = DateTime(now.year - 1, now.month, now.day);
//         break;
//       case 'custom':
//         if (startDate != null && endDate != null) {
//           return entries.where((entry) {
//             DateTime entryDate = DateTime.parse(entry.date);
//             return entryDate.isAfter(startDate) &&
//                 entryDate.isBefore(endDate.add(Duration(days: 1)));
//           }).toList();
//         }
//         break;
//       default:
//         return entries;
//     }
//
//     if (filterStartDate != null) {
//       return entries.where((entry) {
//         DateTime entryDate = DateTime.parse(entry.date);
//         return entryDate.isAfter(filterStartDate!) &&
//             entryDate.isBefore(now.add(Duration(days: 1)));
//       }).toList();
//     }
//
//     return entries;
//   }
//
//
//
//   void _applySorting(List<MilkEntryModel> entries, String sortType) {
//     if (sortType == 'newest') {
//       entries.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
//     } else {
//       entries.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
//     }
//   }
// }

import '../models/milk_entry_model.dart';

class MilkFilterService {
  List<MilkEntryModel> getFilteredAndSortedEntries(
      List<MilkEntryModel> entries,
      String sortType,
      String filterPeriod,
      DateTime? startDate,
      DateTime? endDate,
      [String filterType = 'all']          // أضفت هنا فلتر النوع (افتراضي 'all')
      ) {
    List<MilkEntryModel> filtered = List.from(entries);

    // فلترة حسب النوع
    if (filterType == 'individual') {
      filtered = filtered.where((entry) => (entry.tagNumber != null && entry.tagNumber!.isNotEmpty)).toList();
    } else if (filterType == 'bulk') {
      filtered = filtered.where((entry) => entry.tagNumber == null || entry.tagNumber!.isEmpty).toList();
    }

    if (filterPeriod != 'all') {
      filtered = _applyDateFilter(
          filtered,
          filterPeriod,
          startDate,
          endDate
      );
    }

    _applySorting(filtered, sortType);

    return filtered;
  }

  List<MilkEntryModel> _applyDateFilter(
      List<MilkEntryModel> entries,
      String filterPeriod,
      DateTime? startDate,
      DateTime? endDate,
      ) {
    DateTime now = DateTime.now();
    DateTime? filterStartDate;

    switch (filterPeriod) {
      case 'week':
        filterStartDate = now.subtract(Duration(days: 7));
        break;
      case 'month':
        filterStartDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'halfYear':
        filterStartDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case 'year':
        filterStartDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'custom':
        if (startDate != null && endDate != null) {
          return entries.where((entry) {
            DateTime entryDate = DateTime.parse(entry.date);
            return entryDate.isAfter(startDate) &&
                entryDate.isBefore(endDate.add(Duration(days: 1)));
          }).toList();
        }
        break;
      default:
        return entries;
    }

    if (filterStartDate != null) {
      return entries.where((entry) {
        DateTime entryDate = DateTime.parse(entry.date);
        return entryDate.isAfter(filterStartDate!) &&
            entryDate.isBefore(now.add(Duration(days: 1)));
      }).toList();
    }

    return entries;
  }

  void _applySorting(List<MilkEntryModel> entries, String sortType) {
    if (sortType == 'newest') {
      entries.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    } else {
      entries.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    }
  }
}
