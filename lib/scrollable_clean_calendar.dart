library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/widgets/days_widget.dart';
import 'package:scrollable_clean_calendar/widgets/month_widget.dart';
import 'package:scrollable_clean_calendar/widgets/weekdays_widget.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class ScrollableCleanCalendar extends StatefulWidget {
  /// The language locale
  final String locale;

  /// Scroll controller
  final ScrollController? scrollController;

  /// Obrigatory: The mininimum date to show
  final DateTime minDate;

  /// Obrigatory: The maximum date to show
  final DateTime maxDate;

  /// An initial selected date
  final DateTime? initialDateSelected;

  /// The end of selected range
  final DateTime? endDateSelected;

  /// If is to show or not the weekdays in calendar
  final bool showWeekdays;

  /// In what weekday position the calendar is going to start
  final int weekdayStart;

  /// Function when a day is tapped
  final Function(DateTime date)? onDayTapped;

  /// Function when a range is selected
  final Function(DateTime minDate, DateTime? maxDate)? onRangeSelected;

  /// When a date before the min date is tapped
  final Function(DateTime date)? onPreviousMinDateTapped;

  /// When a date after max date is tapped
  final Function(DateTime date)? onAfterMaxDateTapped;

  /// If the range is enabled
  final bool isRangeMode;

  /// What layout (design) is going to be used
  final Layout? layout;

  /// The space between month and calendar
  final double spaceBetweenMonthAndCalendar;

  /// The space between calendars
  final double spaceBetweenCalendars;

  /// The horizontal space in the calendar dates
  final double calendarCrossAxisSpacing;

  /// The vertical space in the calendar dates
  final double calendarMainAxisSpacing;

  /// The parent padding
  final EdgeInsetsGeometry? padding;

  /// The label text style of month
  final TextStyle? monthTextStyle;

  /// The label text align of month
  final TextAlign? monthTextAlign;

  /// The label text align of month
  final TextStyle? weekdayTextStyle;

  /// The label text style of day
  final TextStyle? dayTextStyle;

  /// The day selected background color
  final Color? daySelectedBackgroundColor;

  /// The day background color
  final Color? dayBackgroundColor;

  /// The day selected background color that is between day selected edges
  final Color? daySelectedBackgroundColorBetween;

  /// The day disable background color
  final Color? dayDisableBackgroundColor;

  /// The radius of day items
  final double dayRadius;

  /// A builder to make a customized month
  final Widget Function(BuildContext context, String month)? monthBuilder;

  /// A builder to make a customized weekday
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;

  /// A builder to make a customized day of calendar
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
    this.weekdayBuilder,
    this.dayBuilder,
    this.monthTextAlign,
    this.monthTextStyle,
    this.weekdayTextStyle,
    this.daySelectedBackgroundColor,
    this.dayBackgroundColor,
    this.daySelectedBackgroundColorBetween,
    this.dayDisableBackgroundColor,
    this.dayTextStyle,
    this.dayRadius = 6,
  }) : assert(layout != null ||
            (monthBuilder != null &&
                weekdayBuilder != null &&
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
    months.add(currentDate);

    while (!(currentDate.year == widget.maxDate.year &&
        currentDate.month == widget.maxDate.month)) {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
      months.add(currentDate);
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
                  weekdayBuilder: widget.weekdayBuilder,
                  textStyle: widget.weekdayTextStyle,
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
                      selectedBackgroundColor:
                          widget.daySelectedBackgroundColor,
                      selectedBackgroundColorBetween:
                          widget.daySelectedBackgroundColorBetween,
                      disableBackgroundColor: widget.dayDisableBackgroundColor,
                      radius: widget.dayRadius,
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
