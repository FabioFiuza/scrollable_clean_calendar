library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/src/week_helper.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/widgets/days_widget.dart';
import 'package:scrollable_clean_calendar/widgets/month_widget.dart';
import 'package:scrollable_clean_calendar/widgets/week_days_widget.dart';

import 'src/week_helper.dart';

class ScrollableCleanCalendar extends StatefulWidget {
  ScrollableCleanCalendar({
    this.locale = 'en',
    this.scrollController,
    required this.minDate,
    required this.maxDate,
    this.initialDateSelected,
    this.endDateSelected,
    this.showDaysWeeks = true,
    this.startWeekDay = DateTime.monday,
    this.onTapDate,
    this.onRangeSelected,
    this.isRangeMode = true,
    this.layout,
    this.calendarCrossAxisSpacing = 4,
    this.calendarMainAxisSpacing = 4,
    this.spaceBetweenCalendars = 24,
    this.spaceBetweenMonthAndCalendar = 24,
    this.padding,
    this.monthBuilder,
    this.weekDayBuilder,
    this.dayBuilder,
  }) : assert(
          (layout != null &&
                  (monthBuilder == null ||
                      weekDayBuilder == null ||
                      dayBuilder == null)) ||
              (layout == null &&
                  (monthBuilder == null ||
                      weekDayBuilder == null ||
                      dayBuilder == null)),
        );

  final String locale;
  final ScrollController? scrollController;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDateSelected;
  final DateTime? endDateSelected;
  final bool showDaysWeeks;
  final int startWeekDay;
  final Function(DateTime date)? onTapDate;
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;
  final bool isRangeMode;
  final Layout? layout;
  final double spaceBetweenMonthAndCalendar;
  final double spaceBetweenCalendars;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext context, String month)? monthBuilder;
  final Widget Function(BuildContext context, String weekDay)? weekDayBuilder;
  final Widget Function(
    BuildContext context, {
    required DateTime day,
    required String text,
    required bool isSelected,
  })? dayBuilder;

  @override
  _ScrollableCleanCalendarState createState() =>
      _ScrollableCleanCalendarState();
}

class _ScrollableCleanCalendarState extends State<ScrollableCleanCalendar> {
  late CleanCalendarController _cleanCalendarController;

  @override
  void initState() {
    initializeDateFormatting();

    _cleanCalendarController = CleanCalendarController(
      startWeekDay: widget.startWeekDay,
      months: WeekHelper.extractWeeks(
          widget.minDate, widget.maxDate, widget.startWeekDay),
      rangeMode: widget.isRangeMode,
      onRangeSelected: widget.onRangeSelected,
      onTapDate: widget.onTapDate,
      maxDate: widget.maxDate,
      minDate: widget.minDate,
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.initialDateSelected != null &&
          (widget.initialDateSelected!.isAfter(widget.minDate) ||
              widget.initialDateSelected!.isSameDay(widget.minDate))) {
        _cleanCalendarController.onDayClick(widget.initialDateSelected!);
      }

      if (widget.endDateSelected != null &&
          (widget.endDateSelected!.isBefore(widget.maxDate) ||
              widget.endDateSelected!.isSameDay(widget.maxDate))) {
        _cleanCalendarController.onDayClick(widget.endDateSelected!);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.scrollController,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      // cacheExtent:
      //     (MediaQuery.of(context).size.width / DateTime.daysPerWeek) * 6,
      separatorBuilder: (_, __) =>
          SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: _cleanCalendarController.months.length,
      itemBuilder: (context, index) {
        final month = _cleanCalendarController.months[index];

        return Column(
          children: [
            MonthWidget(
              month: month,
              locale: widget.locale,
              layout: widget.layout,
              monthBuilder: widget.monthBuilder,
            ),
            SizedBox(height: widget.spaceBetweenMonthAndCalendar),
            Column(
              children: [
                WeekDaysWidget(
                  showDaysWeeks: widget.showDaysWeeks,
                  cleanCalendarController: _cleanCalendarController,
                  locale: widget.locale,
                  layout: widget.layout,
                  weekDayBuilder: widget.weekDayBuilder,
                ),
                AnimatedBuilder(
                  animation: _cleanCalendarController,
                  builder: (_, __) {
                    return DaysWidget(
                      month: month,
                      cleanCalendarController: _cleanCalendarController,
                      calendarCrossAxisSpacing: widget.calendarCrossAxisSpacing,
                      calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                      layout: widget.layout,
                      dayBuilder: widget.dayBuilder,
                    );
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }
}
