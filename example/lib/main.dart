import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable clean calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
          locale: 'en', //default is en
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(
            Duration(days: 365),
          ),
        ),
      ),
    );
  }
}
