import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable clean calendar',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F51B5),
          primaryVariant: Color(0xFF002984),
          secondary: Color(0xFFD32F2F),
          secondaryVariant: Color(0xFF9A0007),
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
        ),
        body: ScrollableCleanCalendar(
          onRangeSelected: (firstDate, secondDate) {},
          onDayTapped: (date) {},
          locale: 'pt',
          layout: Layout.DEFAULT,
          // initialDateSelected: DateTime(2022, 2, 3),
          // endDateSelected: DateTime(2022, 2, 3),
          // calendarCrossAxisSpacing: 4,
          // calendarMainAxisSpacing: 4,
          // calendarCrossAxisSpacing: 0,
          // dayBackgroundColor: Colors.white,
          // dayDisableBackgroundColor: Colors.grey[200],
          // daySelectedBackgroundColor: Colors.red,
          // daySelectedBackgroundColorBetween: Colors.red.withOpacity(.3),
          // showWeekdays: false,
          // monthBuilder: (context, value) {
          //   return Text(
          //     value.toUpperCase(),
          //     style: const TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   );
          // },
          // weekDayBuilder: (context, value) {
          //   return Text(value);
          // },
          // dayBuilder: (context, values) {
          //   return Container(
          //     color: values.isSelected ? Colors.yellow : Colors.transparent,
          //     alignment: Alignment.center,
          //     child: Text(values.text),
          //   );
          // },
          weekdayStart: DateTime.sunday,
          minDate: DateTime(2021, 12, 28),
          maxDate: DateTime(2021, 12, 28).add(const Duration(days: 365)),
        ),
      ),
    );
  }
}
