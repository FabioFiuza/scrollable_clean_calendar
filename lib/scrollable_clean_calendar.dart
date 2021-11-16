library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/widgets/days_widget.dart';
import 'package:scrollable_clean_calendar/widgets/month_widget.dart';
import 'package:scrollable_clean_calendar/widgets/weekdays_widget.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class ScrollableCleanCalendar extends StatefulWidget {
  final String locale;
  final ScrollController? scrollController;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDateSelected;
  final DateTime? endDateSelected;
  final bool showWeekdays;
  final int weekdayStart;
  final Function(DateTime date)? onDayTapped;
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;
  final Function(DateTime date)? onPreviousMinDateTapped;
  final Function(DateTime date)? onAfterMaxDateTapped;
  final bool isRangeMode;
  final Layout? layout;
  final double spaceBetweenMonthAndCalendar;
  final double spaceBetweenCalendars;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? monthTextStyle;
  final TextAlign? monthTextAlign;
  final TextStyle? weekDayTextStyle;
  final TextStyle? dayTextStyle;
  final Color? daySelectedBackgroundColor;
  final Color? dayBackgroundColor;
  final Color? daySelectedBackgroundColorBetween;
  final Color? dayDisableBackgroundColor;
  final double radius;
  final Widget Function(BuildContext context, String month)? monthBuilder;
  final Widget Function(BuildContext context, String weekDay)? weekDayBuilder;
  final Widget Function(BuildContext context, DayValues values)? dayBuilder;

  const ScrollableCleanCalendar({
    this.locale = 'en',
    this.scrollController,
    required this.minDate,
    required this.maxDate,
    this.initialDateSelected,
    this.endDateSelected,
    this.showWeekdays = true,
    this.weekdayStart = DateTime.monday,
    this.onDayTapped,
    this.onRangeSelected,
    this.onPreviousMinDateTapped,
    this.onAfterMaxDateTapped,
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
    this.monthTextAlign,
    this.monthTextStyle,
    this.weekDayTextStyle,
    this.daySelectedBackgroundColor,
    this.dayBackgroundColor,
    this.daySelectedBackgroundColorBetween,
    this.dayDisableBackgroundColor,
    this.dayTextStyle,
    this.radius = 6,
  }) : assert(layout != null ||
            (monthBuilder != null &&
                weekDayBuilder != null &&
                dayBuilder != null));

  @override
  _ScrollableCleanCalendarState createState() =>
      _ScrollableCleanCalendarState();
}

class _ScrollableCleanCalendarState extends State<ScrollableCleanCalendar> {
  late CleanCalendarController _cleanCalendarController;

  @override
  void initState() {
    initializeDateFormatting();
    List<DateTime> months = [];

    DateTime currentDate = DateTime(widget.minDate.year, widget.minDate.month);

    while (!(currentDate.year != widget.maxDate.year &&
        currentDate.month != widget.maxDate.month)) {
      months.add(currentDate);
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    _cleanCalendarController = CleanCalendarController(
      startWeekDay: widget.weekdayStart,
      months: months,
      rangeMode: widget.isRangeMode,
      onRangeSelected: widget.onRangeSelected,
      onTapDate: widget.onDayTapped,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: MonthWidget(
                month: month,
                locale: widget.locale,
                layout: widget.layout,
                monthBuilder: widget.monthBuilder,
                textAlign: widget.monthTextAlign,
                textStyle: widget.monthTextStyle,
              ),
            ),
            SizedBox(height: widget.spaceBetweenMonthAndCalendar),
            Column(
              children: [
                WeekdaysWidget(
                  showWeekdays: widget.showWeekdays,
                  cleanCalendarController: _cleanCalendarController,
                  locale: widget.locale,
                  layout: widget.layout,
                  weekDayBuilder: widget.weekDayBuilder,
                  textStyle: widget.weekDayTextStyle,
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
                      onAfterMaxDateTapped: widget.onAfterMaxDateTapped,
                      onPreviousMinDateTapped: widget.onPreviousMinDateTapped,
                      backgroundColor: widget.dayBackgroundColor,
                      selectedColor: widget.daySelectedBackgroundColor,
                      selectedColorBetween:
                          widget.daySelectedBackgroundColorBetween,
                      disableColor: widget.dayDisableBackgroundColor,
                      radius: widget.radius,
                      textStyle: widget.dayTextStyle,
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
