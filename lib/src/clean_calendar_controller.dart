import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class CleanCalendarController extends ChangeNotifier {
  final int startWeekDay;
  final bool rangeMode;
  final List<DateTime> months;
  final DateTime minDate;
  final DateTime maxDate;
  final Function(DateTime date)? onTapDate;
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;

  late int endWeekDay;

  CleanCalendarController({
    required this.months,
    required this.rangeMode,
    required this.onTapDate,
    required this.onRangeSelected,
    required this.minDate,
    required this.maxDate,
    this.startWeekDay = DateTime.sunday,
  })  : assert(startWeekDay <= DateTime.sunday),
        assert(startWeekDay >= DateTime.monday) {
    final x = startWeekDay - 1;
    endWeekDay = x == 0 ? 7 : x;
  }

  DateTime? rangeMinDate;
  DateTime? rangeMaxDate;

  List<String> getDaysOfWeek([String locale = 'pt']) {
    var today = DateTime.now();

    while (today.weekday != startWeekDay) {
      today = today.subtract(const Duration(days: 1));
    }
    final dateFormat = DateFormat(DateFormat.ABBR_WEEKDAY, locale);
    final daysOfWeek = [
      dateFormat.format(today),
      dateFormat.format(today.add(const Duration(days: 1))),
      dateFormat.format(today.add(const Duration(days: 2))),
      dateFormat.format(today.add(const Duration(days: 3))),
      dateFormat.format(today.add(const Duration(days: 4))),
      dateFormat.format(today.add(const Duration(days: 5))),
      dateFormat.format(today.add(const Duration(days: 6)))
    ];

    return daysOfWeek;
  }

  void onDayClick(DateTime date) {
    if (rangeMode) {
      if (rangeMinDate == null || rangeMaxDate != null) {
        rangeMinDate = date;
        rangeMaxDate = null;
      } else if (date.isBefore(rangeMinDate!)) {
        rangeMaxDate = rangeMinDate;
        rangeMinDate = date;
      } else if (date.isAfter(rangeMinDate!) || date.isSameDay(rangeMinDate!)) {
        rangeMaxDate = date;
      }
    } else {
      rangeMinDate = date;
      rangeMaxDate = date;
    }

    notifyListeners();

    if (onTapDate != null) {
      onTapDate!(date);
    }

    if (onRangeSelected != null) {
      onRangeSelected!(rangeMinDate!, rangeMaxDate);
    }
  }
}
