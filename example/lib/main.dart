import 'package:flutter/material.dart';
import 'package:scrolling_clean_calendar/scrolling_clean_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ScrollingCleanCalendar'),
        ),
        body: ScrollingCleanCalendar(
          onRangeSelected: (firstDate, secondDate) {
            print('date 1 $firstDate');
            print('date 2 $secondDate');
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
