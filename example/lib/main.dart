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
        colorScheme: ColorScheme(
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
          title: Text('ScrollableCleanCalendar'),
        ),
        body: ScrollableCleanCalendar(
          onRangeSelected: (firstDate, secondDate) {
            print('onRangeSelected first $firstDate');
            print('onRangeSelected second $secondDate');
          },
          onTapDate: (date) {
            print('onTap $date');
          },
          locale: 'pt',
          layout: Layout.BEAUTY,
          calendarCrossAxisSpacing: 0,
          startWeekDay: DateTime.sunday,
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(Duration(days: 365)),
        ),
      ),
    );
  }
}
