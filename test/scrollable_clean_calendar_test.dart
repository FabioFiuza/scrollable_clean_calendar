import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';

void main() {
  DateTime firstDateYear = DateTime(2020);

  Widget buildScrollableCleanCalendar({
    String locale,
    DateTime minDate,
    DateTime maxDate,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ScrollableCleanCalendar(
            onRangeSelected: (firstDate, secondDate) {
              print('date 1 $firstDate');
              print('date 2 $secondDate');
            },
            locale: locale ?? 'en', //default is en
            minDate: minDate ?? firstDateYear,
            maxDate: maxDate ??
                firstDateYear.add(
                  Duration(days: 365),
                ),
          ),
        ),
      ),
    );
  }

  testWidgets('Should to render calendar successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar());
    await tester.pump();

    expect(find.byKey(ValueKey('Calendar0')), findsOneWidget);
    expect(find.text('January 2020'), findsOneWidget);
    expect(find.text('February 2020'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0.0, -2000));
    await tester.pump();

    expect(find.byKey(ValueKey('Calendar11')), findsOneWidget);
    expect(find.text('December 2020'), findsOneWidget);
  });

  testWidgets('Calendar have not date before minDate',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar());

    expect(find.text('January 2019'), findsNothing);
    expect(find.text('February 2019'), findsNothing);
  });

  testWidgets(
      'Calendar have not date after maxDate', (WidgetTester tester) async {});

  testWidgets(
      'When click at a range date onRageSelected should return the two dates',
      (WidgetTester tester) async {});

  testWidgets(
      'When the properties showDayWeeks have false, the calendar not show the days of week label',
      (WidgetTester tester) async {});

  testWidgets(
      'When the properties showDayWeeks have false, the calendar not show the days of week label',
      (WidgetTester tester) async {});

  testWidgets(
      'Should to show calendar with locale PT', (WidgetTester tester) async {});
}
