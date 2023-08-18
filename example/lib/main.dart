import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

void main() {
  runApp(MyApp());
}

const expectedValue = <int, dynamic>{
  1690822800000: {"t": 1690822800000, "p": 2.56, "a": 234910.00},
  1690909200000: {"t": 1690909200000, "p": -2.56, "a": 234910.00},
  1690995600000: {"t": 1690995600000, "p": -2.56, "a": 234910.00},
};

class MyApp extends StatelessWidget {
  final calendarController = CleanCalendarController(
    minDate: DateTime(2010),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    initialDateSelected: DateTime.now(),
    onDayTapped: (date) {},
    // readOnly: true,
    rangeMode: false,
    weekdayStart: DateTime.monday,
    viewMode: ViewMode.scrollableMonth,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable Clean Calendar',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F51B5),
          primaryContainer: Color(0xFF002984),
          secondary: Color(0xFFD32F2F),
          secondaryContainer: Color(0xFF9A0007),
          surface: Color(0xFFDEE2E6),
          background: Color(0xFFF8F9FA),
          error: Color(0xFF96031A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scrollable Clean Calendar'),
          actions: [
            IconButton(
              onPressed: () {
                calendarController.clearSelectedDates();
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        body: ScrollableCleanCalendar(
          calendarController: calendarController,
          layout: Layout.DEFAULT,
          calendarCrossAxisSpacing: 0,
          calendarMainAxisSpacing: 0,
          locale: 'id',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          weekdayBuilder: (context, week) => Center(
            child: Text(
              week,
              style: TextStyle(
                color: Color(0xffBEC5D0),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          dayBuilder: (context, dayValues) {
            final value = expectedValue.entries.singleWhere(
                (element) =>
                    element.key == dayValues.day.millisecondsSinceEpoch,
                orElse: () => MapEntry(0, null));
            final percentage = (value.value?['p'] as double?) ?? 0;
            return Container(
              decoration: BoxDecoration(
                color: percentage == 0.0
                    ? Colors.white
                    : percentage.isNegative
                        ? Color(0xffFDEBF0)
                        : Color(0xffE7FEFF),
                // borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dayValues.isSelected
                          ? Color(0xff00B7BD)
                          : Colors.transparent,
                    ),
                    child: Text(
                      dayValues.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dayValues.isSelected
                            ? Colors.white
                            : Color(0xff3D4A5C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    percentage.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: percentage == 0.0
                          ? Color(0xff3D4A5C)
                          : percentage.isNegative
                              ? Color(0xffED3768)
                              : Color(0xff00B59D),
                    ),
                  ),
                ],
              ),
            );
          },
          // monthBuilder: (context, monthValues) {
          //   return Container(
          //     decoration: BoxDecoration(
          //       color: monthValues.month.month.isEven
          //           ? Color(0xffFDEBF0)
          //           : Color(0xffE7FEFF),
          //       // borderRadius: BorderRadius.circular(8),
          //     ),
          //     alignment: Alignment.center,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           padding: const EdgeInsets.all(8),
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: monthValues.isSelected
          //                 ? Color(0xff00B7BD)
          //                 : Colors.transparent,
          //           ),
          //           child: Text(
          //             monthValues.text,
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w600,
          //               color: monthValues.isSelected
          //                   ? Colors.white
          //                   : Color(0xff3D4A5C),
          //             ),
          //           ),
          //         ),
          //         if (monthValues.month.month != 3) ...[
          //           const SizedBox(height: 4),
          //           Text(
          //             '-1,54%',
          //             style: TextStyle(
          //               fontSize: 10,
          //               fontWeight: FontWeight.w600,
          //               color: Color(0xff00B59D),
          //             ),
          //           ),
          //         ]
          //       ],
          //     ),
          //   );
          // },
        ),
      ),
    );
  }
}
