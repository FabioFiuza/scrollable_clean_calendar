library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/widgets/days_widget.dart';
import 'package:scrollable_clean_calendar/widgets/month_widget.dart';
import 'package:scrollable_clean_calendar/widgets/weekdays_widget.dart';

class ScrollableCleanCalendar extends StatefulWidget {
  /// The language locale
  final String locale;

  /// Scroll controller
  final ScrollController? scrollController;

  /// If is to show or not the weekdays in calendar
  final bool showWeekdays;

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

  /// The controller of ScrollableCleanCalendar
  final CleanCalendarController calendarController;

  const ScrollableCleanCalendar({
    this.locale = 'en',
    this.scrollController,
    this.showWeekdays = true,
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
    required this.calendarController,
  }) : assert(layout != null || (monthBuilder != null && weekdayBuilder != null && dayBuilder != null));

  @override
  _ScrollableCleanCalendarState createState() => _ScrollableCleanCalendarState();
}

class _ScrollableCleanCalendarState extends State<ScrollableCleanCalendar> {
  @override
  void initState() {
    initializeDateFormatting();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.scrollController,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      // cacheExtent:
      //     (MediaQuery.of(context).size.width / DateTime.daysPerWeek) * 6,
      separatorBuilder: (_, __) => SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: widget.calendarController.months.length,
      reverse: widget.calendarController.reverse,
      physics: widget.calendarController.physics,
      itemBuilder: (context, index) {
        final month = widget.calendarController.months[index];

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
                  cleanCalendarController: widget.calendarController,
                  locale: widget.locale,
                  layout: widget.layout,
                  weekdayBuilder: widget.weekdayBuilder,
                  textStyle: widget.weekdayTextStyle,
                ),
                AnimatedBuilder(
                  animation: widget.calendarController,
                  builder: (_, __) {
                    return DaysWidget(
                      month: month,
                      cleanCalendarController: widget.calendarController,
                      calendarCrossAxisSpacing: widget.calendarCrossAxisSpacing,
                      calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                      layout: widget.layout,
                      dayBuilder: widget.dayBuilder,
                      backgroundColor: widget.dayBackgroundColor,
                      selectedBackgroundColor: widget.daySelectedBackgroundColor,
                      selectedBackgroundColorBetween: widget.daySelectedBackgroundColorBetween,
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
