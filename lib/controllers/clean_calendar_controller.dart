import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class CleanCalendarController extends ChangeNotifier {
  /// Obrigatory: The mininimum date to show
  final DateTime minDate;

  /// Obrigatory: The maximum date to show
  final DateTime maxDate;

  /// If the range is enabled
  final bool rangeMode;

  /// If the calendar is readOnly
  final bool readOnly;

  /// In what weekday position the calendar is going to start
  final int weekdayStart;

  /// Function when a day is tapped
  final Function(DateTime date)? onDayTapped;

  /// Function when a range is selected
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;

  /// When a date before the min date is tapped
  final Function(DateTime date)? onPreviousMinDateTapped;

  /// When a date after max date is tapped
  final Function(DateTime date)? onAfterMaxDateTapped;

  /// An initial selected date
  final DateTime? initialDateSelected;

  /// The end of selected range
  final DateTime? endDateSelected;

  /// The physics of ListView
  final ScrollPhysics? physics;

  /// The reverse of ListView
  final bool reverse;

  late int weekdayEnd;
  List<DateTime> months = [];

  CleanCalendarController({
    required this.minDate,
    required this.maxDate,
    this.rangeMode = true,
    this.readOnly = false,
    this.endDateSelected,
    this.initialDateSelected,
    this.onDayTapped,
    this.onRangeSelected,
    this.onAfterMaxDateTapped,
    this.onPreviousMinDateTapped,
    this.weekdayStart = DateTime.monday,
    this.reverse = false,
    this.physics,
  })  : assert(weekdayStart <= DateTime.sunday),
        assert(weekdayStart >= DateTime.monday) {
    final x = weekdayStart - 1;
    weekdayEnd = x == 0 ? 7 : x;

    DateTime currentDate = DateTime(minDate.year, minDate.month);
    if (reverse) {
      months.insert(0, currentDate);
    } else {
      months.add(currentDate);
    }

    while (!(currentDate.year == maxDate.year && currentDate.month == maxDate.month)) {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
      if (reverse) {
        months.insert(0, currentDate);
      } else {
        months.add(currentDate);
      }
    }

    if (initialDateSelected != null && (initialDateSelected!.isAfter(minDate) || initialDateSelected!.isSameDay(minDate))) {
      onDayClick(initialDateSelected!, update: false);
    }

    if (endDateSelected != null && (endDateSelected!.isBefore(maxDate) || endDateSelected!.isSameDay(maxDate))) {
      onDayClick(endDateSelected!, update: false);
    }
  }

  DateTime? rangeMinDate;
  DateTime? rangeMaxDate;

  List<String> getDaysOfWeek([String locale = 'pt']) {
    var today = DateTime.now();

    while (today.weekday != weekdayStart) {
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

  void onDayClick(DateTime date, {bool update = true}) {
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

    if (update) {
      notifyListeners();

      if (onDayTapped != null) {
        onDayTapped!(date);
      }

      if (onRangeSelected != null) {
        onRangeSelected!(rangeMinDate!, rangeMaxDate);
      }
    }
  }

  void clearSelectedDates() {
    rangeMaxDate = null;
    rangeMinDate = null;

    notifyListeners();
  }
}
