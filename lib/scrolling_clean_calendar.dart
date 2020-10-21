library scrolling_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_clean_calendar/to/month.dart';
import 'package:scrolling_clean_calendar/utils/date_utils.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class ScrollingCleanCalendar extends StatefulWidget {
  ScrollingCleanCalendar({
    Key key,
    this.locale = 'en',
    @required this.minDate,
    @required this.maxDate,
    this.showDaysWeeks = true,
    this.monthLabelStyle,
    this.dayLabelStyle,
    this.dayWeekLabelStyle,
  })  : assert(minDate != null),
        assert(maxDate != null),
        assert(showDaysWeeks != null),
        super(key: key);

  final String locale;
  final bool showDaysWeeks;
  final DateTime minDate;
  final DateTime maxDate;
  final TextStyle monthLabelStyle;
  final TextStyle dayLabelStyle;
  final TextStyle dayWeekLabelStyle;

  @override
  _ScrollingCleanCalendarState createState() => _ScrollingCleanCalendarState();
}

class _ScrollingCleanCalendarState extends State<ScrollingCleanCalendar> {
  List<Month> months;

  @override
  void initState() {
    initializeDateFormatting();
    months = DateUtils.extractWeeks(widget.minDate, widget.maxDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              _buildMonthLabelRow(month, context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Table(
                  children: [
                    _buildDayWeeksRow(context),
                    ...month.weeks.map(
                      (Week week) {
                        DateTime firstDay = week.firstDay;
                        bool rangeFeatureEnabled = false;

                        return _buildDaysRow(week, firstDay, context);
                      },
                    ).toList(growable: false),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  TableRow _buildDaysRow(Week week, DateTime firstDay, BuildContext context) {
    return TableRow(
      children: List<Widget>.generate(
        DateTime.daysPerWeek,
        (int position) {
          DateTime day = DateTime(week.firstDay.year, week.firstDay.month,
              firstDay.day + (position - (firstDay.weekday - 1)));

          if ((position + 1) < week.firstDay.weekday ||
              (position + 1) > week.lastDay.weekday ||
              day.isBefore(widget.minDate) ||
              day.isAfter(widget.maxDate)) {
            return SizedBox.shrink();
          } else {
            return TableCell(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Text(
                    DateFormat('d', widget.locale).format(day),
                    style: widget.dayLabelStyle ??
                        Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.black),
                  ),
                ),
              ),
            );
          }
        },
        growable: false,
      ),
    );
  }

  TableRow _buildDayWeeksRow(BuildContext context) {
    return widget.showDaysWeeks
        ? TableRow(
            children: [
              for (var i = 0; i < DateTime.daysPerWeek; i++)
                TableCell(
                  child: Center(
                    child: Text(
                      DateUtils.getDaysOfWeek(widget.locale)[i].capitalize(),
                      style: widget.dayWeekLabelStyle ??
                          Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
            ],
          )
        : SizedBox.shrink();
  }

  Widget _buildMonthLabelRow(Month month, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('MMMM yyyy', widget.locale)
              .format(
                DateTime(month.year, month.month),
              )
              .capitalize(),
          style: widget.monthLabelStyle ??
              Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.grey[800],
                  ),
        ),
      ],
    );
  }
}
