import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';

void main() {
  DateTime firstDateYear = DateTime(2020);

  Widget buildScrollableCleanCalendar({
    String locale,
    DateTime minDate,
    DateTime maxDate,
    bool showDayWeeks,
    RangeDate onRangeSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ScrollableCleanCalendar(
            onRangeSelected: onRangeSelected ??
                (firstDate, secondDate) {
                  print('date 1 $firstDate');
                  print('date 2 $secondDate');
                },
            locale: locale ?? 'en', //default is en
            minDate: minDate ?? firstDateYear,
            showDaysWeeks: showDayWeeks ?? true,
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

  testWidgets('The days in the calendar can not be less than minDate',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar());

    expect(find.text('January 2019'), findsNothing);
    expect(find.text('February 2019'), findsNothing);
  });

  testWidgets('The days in the calendar can not be bigger than maxDate',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar());
    expect(find.text('January 2022'), findsNothing);
    expect(find.text('February 2022'), findsNothing);
  });

  testWidgets(
      'When click at a range date onRageSelected should return the two dates',
      (WidgetTester tester) async {
    final dateFormat = DateFormat('dd-MM-yyyy');

    await tester.pumpWidget(
        buildScrollableCleanCalendar(onRangeSelected: (firstDate, secondDate) {
      expect(dateFormat.format(firstDate), '01-01-2020');
      if (secondDate != null) {
        expect(dateFormat.format(secondDate), '03-03-2020');
      }
    }));

    await tester.tap(find.byKey(ValueKey('01-01-2020')));
    await tester.tap(find.byKey(ValueKey('03-03-2020')));
  });

  testWidgets(
      'When the properties showDayWeeks have false, the calendar not show the days of week label',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar(showDayWeeks: false));

    expect(find.text('Sun'), findsNothing);
    expect(find.text('Mon'), findsNothing);
    expect(find.text('Sat'), findsNothing);
  });

  testWidgets('Should to show calendar with locale PT',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar(locale: 'pt'));
    expect(find.text('Janeiro 2020'), findsOneWidget);
    expect(find.text('Fevereiro 2020'), findsOneWidget);
  });
}
