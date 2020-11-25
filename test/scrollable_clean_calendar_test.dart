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
    SelectDate onTapDate,
    int startWeekDay,
    bool renderPostAndPreviousMonthDates,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ScrollableCleanCalendar(
            onTapDate: onTapDate ?? (date) {},
            onRangeSelected: onRangeSelected ?? (firstDate, secondDate) {},
            locale: locale ?? 'en', //default is en
            minDate: minDate ?? firstDateYear,
            showDaysWeeks: showDayWeeks ?? true,
            maxDate: maxDate ??
                firstDateYear.add(
                  Duration(days: 365),
                ),
            startWeekDay: startWeekDay ?? DateTime.monday,
            renderPostAndPreviousMonthDates:
                renderPostAndPreviousMonthDates ?? false,
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

  testWidgets('When click on a date onTapDate should return this date',
      (WidgetTester tester) async {
    final dateFormat = DateFormat('dd-MM-yyyy');

    await tester.pumpWidget(buildScrollableCleanCalendar(onTapDate: (date) {
      expect(dateFormat.format(date), '02-03-2020');
    }));

    await tester.tap(find.byKey(ValueKey('02-03-2020')));
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

  testWidgets('Should start on Monday', (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar(
      locale: 'pt',
      startWeekDay: DateTime.monday,
    ));
    var byKey = tester.firstWidget(find.byKey(ValueKey('WeekLabel0'))) as Text;
    expect(byKey.data, "Seg");

    byKey = tester.firstWidget(find.byKey(ValueKey('WeekLabel6'))) as Text;
    expect(byKey.data, "Dom");
  });

  testWidgets('Should start on Sunday', (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar(
      locale: 'pt',
      startWeekDay: DateTime.sunday,
    ));
    var byKey = tester.firstWidget(find.byKey(ValueKey('WeekLabel0'))) as Text;
    expect(byKey.data, "Dom");

    byKey = tester.firstWidget(find.byKey(ValueKey('WeekLabel6'))) as Text;
    expect(byKey.data, "Sáb");
  });

  testWidgets(
      'Should show previous and post dates of month when renderPostAndPreviousMonthDates is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildScrollableCleanCalendar(
      locale: 'pt',
      minDate: DateTime(2020, 2, 15),
      maxDate: DateTime(2020, 5, 15),
      renderPostAndPreviousMonthDates: true,
    ));

    var previousDateOfMonth = find.byKey(ValueKey('01-02-2020'));
    expect(previousDateOfMonth, findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0.0, -2000));
    await tester.pump();

    var postDateOfMonth = find.byKey(ValueKey('20-05-2020'));
    expect(postDateOfMonth, findsOneWidget);
  });
}
