library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/src/week_helper.dart';
import 'package:vertical_calendar/utils/date_models.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

typedef RangeDate = Function(DateTime minDate, DateTime maxDate);
typedef SelectDate = Function(DateTime date);
typedef TextStyleFunction = Function(bool isSelected);

class ScrollableCleanCalendar extends StatefulWidget {
  ScrollableCleanCalendar({
    Key key,
    this.locale = 'en',
    @required this.minDate,
    @required this.maxDate,
    this.onRangeSelected,
    this.showDaysWeeks = true,
    this.monthLabelStyle,
    this.dayLabelStyle,
    this.dayWeekLabelStyle,
    this.selectedDateColor,
    this.rangeSelectedDateColor,
    this.selectDateRadius = 15,
    this.onTapDate,
    this.startWeekDay = DateTime.monday,
  })  : assert(minDate != null),
        assert(maxDate != null),
        assert(showDaysWeeks != null),
        assert(selectDateRadius != null),
        super(key: key);

  final String locale;
  final bool showDaysWeeks;
  final DateTime minDate;
  final DateTime maxDate;
  final int startWeekDay;

  final double selectDateRadius;

  final RangeDate onRangeSelected;
  final TextStyleFunction dayLabelStyle;
  final SelectDate onTapDate;

  ///Styles
  final TextStyle monthLabelStyle;
  final TextStyle dayWeekLabelStyle;
  final Color selectedDateColor;
  final Color rangeSelectedDateColor;

  @override
  _ScrollableCleanCalendarState createState() =>
      _ScrollableCleanCalendarState();
}

class _ScrollableCleanCalendarState extends State<ScrollableCleanCalendar> {
  CleanCalendarController _cleanCalendarController;

  List<Month> months;
  DateTime rangeMinDate;
  DateTime rangeMaxDate;
  DateTime _minDate;
  DateTime _maxDate;

  @override
  void initState() {
    initializeDateFormatting();
    _minDate =
        DateTime(widget.minDate.year, widget.minDate.month, widget.minDate.day);
    _maxDate = DateTime(widget.maxDate.year, widget.maxDate.month,
        widget.maxDate.day, 23, 59, 00);
    months = WeekHelper.extractWeeks(_minDate, _maxDate, widget.startWeekDay);
    _cleanCalendarController =
        CleanCalendarController(startWeekDay: widget.startWeekDay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent:
          (MediaQuery.of(context).size.width / DateTime.daysPerWeek) * 6,
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
                  key: ValueKey('Calendar$index'),
                  children: [
                    _buildDayWeeksRow(context),
                    ...month.weeks.map(
                      (Week week) {
                        DateTime firstDay = week.firstDay;

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
    // _cleanCalendarController.dayOfWeek()
    return TableRow(
      children: List<Widget>.generate(
        DateTime.daysPerWeek,
        (int position) {
          DateTime day = DateTime(
              week.firstDay.year,
              week.firstDay.month,
              firstDay.day +
                  (position - (firstDay.weekday - widget.startWeekDay)));

          if ((position + widget.startWeekDay) < week.firstDay.weekday ||
              (position + widget.startWeekDay) > week.lastDay.weekday ||
              day.isBefore(_minDate) ||
              day.isAfter(_maxDate)) {
            return SizedBox.shrink();
          } else {
            bool rangeFeatureEnabled = rangeMinDate != null;

            bool isSelected = false;

            if (rangeFeatureEnabled) {
              if (rangeMinDate != null && rangeMaxDate != null) {
                isSelected = day.isSameDayOrAfter(rangeMinDate) &&
                    day.isSameDayOrBefore(rangeMaxDate);
              } else {
                isSelected = day.isAtSameMomentAs(rangeMinDate);
              }
            }
            return TableCell(
              key:
                  ValueKey(DateFormat('dd-MM-yyyy', widget.locale).format(day)),
              child: GestureDetector(
                onTap: () {
                  _onDayClick(day);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(
                        _getRadiusRangeMinDate(isSelected, day),
                      ),
                      right: Radius.circular(
                        _getRadiusRangeMaxDate(isSelected, day),
                      ),
                    ),
                    color: _getBackgroundColor(isSelected, day),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        DateFormat('d', widget.locale).format(day),
                        style: widget.dayLabelStyle != null
                            ? widget.dayLabelStyle(isSelected)
                            : Theme.of(context).textTheme.bodyText2.copyWith(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                      ),
                    ),
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

  double _getRadiusRangeMinDate(bool isSelected, DateTime day) {
    if (isSelected) {
      if (day.compareTo(rangeMinDate) == 0 && rangeMaxDate != null) {
        return widget.selectDateRadius;
      }
    }
    return 0;
  }

  double _getRadiusRangeMaxDate(bool isSelected, DateTime day) {
    if (isSelected) {
      if (rangeMaxDate != null && day.compareTo(rangeMaxDate) == 0) {
        return widget.selectDateRadius;
      }
    }
    return 0;
  }

  Color _getBackgroundColor(bool isSelected, DateTime day) {
    if (isSelected) {
      if (day.compareTo(rangeMinDate) == 0 ||
          (rangeMaxDate != null && day.compareTo(rangeMaxDate) == 0)) {
        return widget.selectedDateColor ?? Colors.indigo;
      } else {
        return widget.rangeSelectedDateColor ?? Colors.blue;
      }
    }
    return Colors.transparent;
  }

  TableRow _buildDayWeeksRow(BuildContext context) {
    return widget.showDaysWeeks
        ? TableRow(
            children: [
              for (var i = 0; i < DateTime.daysPerWeek; i++)
                TableCell(
                  child: Center(
                    child: Text(
                      _cleanCalendarController
                          .getDaysOfWeek(widget.locale)[i]
                          .capitalize(),
                      key: ValueKey("WeekLabel$i"),
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
        : TableRow(children: [
            for (var i = 0; i < DateTime.daysPerWeek; i++)
              TableCell(child: SizedBox.shrink())
          ]);
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

  void _onDayClick(DateTime date) {
    if (rangeMinDate == null || rangeMaxDate != null) {
      setState(() {
        rangeMinDate = date;
        rangeMaxDate = null;
      });
    } else if (date.isBefore(rangeMinDate)) {
      setState(() {
        rangeMaxDate = rangeMinDate;
        rangeMinDate = date;
      });
    } else if (date.isAfter(rangeMinDate)) {
      setState(() {
        rangeMaxDate = date;
      });
    }

    if (widget.onTapDate != null) {
      widget.onTapDate(date);
    }

    if (widget.onRangeSelected != null) {
      widget.onRangeSelected(rangeMinDate, rangeMaxDate);
    }
  }
}
