import 'package:intl/intl.dart';

class CleanCalendarController {
  final startWeekDay;

  CleanCalendarController({this.startWeekDay = DateTime.sunday})
      : assert(startWeekDay <= DateTime.sunday),
        assert(startWeekDay >= DateTime.monday);

  List<String> getDaysOfWeek([String locale]) {
    var today = DateTime.now();

    while (today.weekday != startWeekDay) {
      today = today.subtract(Duration(days: 1));
    }
    final dateFormat = DateFormat(DateFormat.ABBR_WEEKDAY, locale);
    final daysOfWeek = [
      dateFormat.format(today),
      dateFormat.format(today.add(Duration(days: 1))),
      dateFormat.format(today.add(Duration(days: 2))),
      dateFormat.format(today.add(Duration(days: 3))),
      dateFormat.format(today.add(Duration(days: 4))),
      dateFormat.format(today.add(Duration(days: 5))),
      dateFormat.format(today.add(Duration(days: 6)))
    ];

    return daysOfWeek;
  }
}
