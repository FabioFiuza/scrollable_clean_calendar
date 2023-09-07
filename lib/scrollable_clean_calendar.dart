library scrollable_clean_calendar;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/models/month_values_model.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';
import 'package:scrollable_clean_calendar/widgets/days_widget.dart';
import 'package:scrollable_clean_calendar/widgets/month_compact_view.dart';
import 'package:scrollable_clean_calendar/widgets/month_widget.dart';
import 'package:scrollable_clean_calendar/widgets/weekdays_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  final double childAspectRationDay;

  final double childAspectRatioMonth;

  /// The parent padding
  final EdgeInsets? padding;

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

  /// The day disable color
  final Color? dayDisableColor;

  /// The dropdown background color
  final Color? dropdownButtonColor;

  /// The calendar view background color
  final Color? monthViewCalendarBackground;

  /// The radius of day items
  final double dayRadius;

  /// The dropdown icon widget
  final Widget? dropdownIconWidget;

  /// it used when use [yearSelection()] / [monthSelection()] default builder
  final Function(DateTime)? onTimeChange;

  final Widget Function(ViewMode viewMode)? switchViewWidget;

  /// A builder to make a customized month
  final Widget Function(BuildContext context, MonthValues month)? monthBuilder;

  /// A builder to make a customized weekday
  final Widget Function(BuildContext context, String weekday)? weekdayBuilder;

  /// A builder to make a customized day of calendar
  final Widget Function(BuildContext context, DayValues values)? dayBuilder;

  /// Right now it's just passing on tap function to another build in [yearSelection()] / [monthSelection()]
  /// Might be change if need to fully customized [yearSelection()] / [monthSelection()]
  final Future<DateTime?> Function()? onTapSwitchDateTime;

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
    this.dayDisableColor,
    this.dropdownButtonColor,
    this.dropdownIconWidget,
    this.monthViewCalendarBackground,
    this.switchViewWidget,
    this.dayTextStyle,
    this.dayRadius = 6,
    this.onTimeChange,
    this.onTapSwitchDateTime,
    this.childAspectRationDay = 1.0,
    this.childAspectRatioMonth = 1.0,
    required this.calendarController,
  }) : assert(layout != null ||
            (monthBuilder != null &&
                weekdayBuilder != null &&
                dayBuilder != null));

  @override
  State<ScrollableCleanCalendar> createState() =>
      _ScrollableCleanCalendarState();
}

class _ScrollableCleanCalendarState extends State<ScrollableCleanCalendar> {
  @override
  void initState() {
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final focusDate = widget.calendarController.initialFocusDate;
      if (focusDate != null) {
        widget.calendarController.jumpToMonth(date: focusDate);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.calendarController.currentViewMode == ViewMode.scrollableMonth) {
      if (widget.scrollController != null) {
        return listViewCalendar();
      } else {
        return scrollablePositionedListCalendar();
      }
    }
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          ListenableBuilder(
            listenable: widget.calendarController,
            builder: (context, __) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.calendarController.currentViewMode ==
                    ViewMode.compactMonth)
                  monthSelection(widget.calendarController.monthsInOption),
                if (widget.calendarController.currentViewMode ==
                    ViewMode.compactYear)
                  yearSelection(widget.calendarController.years),
                widget.switchViewWidget != null
                    ? widget.switchViewWidget!
                        .call(widget.calendarController.currentViewMode)
                    : viewMode(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: widget.calendarController,
            builder: (_, __) {
              return Column(
                children: [
                  if (widget.calendarController.currentViewMode ==
                      ViewMode.compactYear)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: MonthCompactView(
                        month: widget.calendarController.selectedMonth,
                        cleanCalendarController: widget.calendarController,
                        locale: widget.locale,
                        monthBuilder: widget.monthBuilder,
                        calendarCrossAxisSpacing:
                            widget.calendarCrossAxisSpacing,
                        calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                        childAspectRatio: widget.childAspectRatioMonth,
                      ),
                    ),
                  if (widget.calendarController.currentViewMode ==
                      ViewMode.compactMonth) ...[
                    WeekdaysWidget(
                      showWeekdays: widget.showWeekdays,
                      cleanCalendarController: widget.calendarController,
                      locale: widget.locale,
                      layout: widget.layout,
                      weekdayBuilder: widget.weekdayBuilder,
                      textStyle: widget.weekdayTextStyle,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: widget.monthViewCalendarBackground ??
                            Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: DaysWidget(
                        month: widget.calendarController.selectedMonth,
                        cleanCalendarController: widget.calendarController,
                        calendarCrossAxisSpacing:
                            widget.calendarCrossAxisSpacing,
                        calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                        childAspectRatio: widget.childAspectRationDay,
                        layout: widget.layout,
                        dayBuilder: widget.dayBuilder,
                        backgroundColor: widget.dayBackgroundColor,
                        selectedBackgroundColor:
                            widget.daySelectedBackgroundColor,
                        selectedBackgroundColorBetween:
                            widget.daySelectedBackgroundColorBetween,
                        disableBackgroundColor:
                            widget.dayDisableBackgroundColor,
                        dayDisableColor: widget.dayDisableColor,
                        radius: widget.dayRadius,
                        textStyle: widget.dayTextStyle,
                      ),
                    )
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget monthSelection(List<DateTime> month) {
    if (widget.onTapSwitchDateTime != null) {
      return GestureDetector(
        onTap: () async => await widget.onTapSwitchDateTime?.call(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xff00B7BD)),
          ),
          child: ListenableBuilder(
            listenable: widget.calendarController,
            builder: (_, __) {
              final value = widget.calendarController.selectedMonth;
              return Text(
                '${DateFormat('MMMM', widget.locale).format(DateTime(value.year, value.month)).capitalize()} ${DateFormat('yyyy', widget.locale).format(DateTime(value.year, value.month))}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff00B7BD),
                ),
              );
            },
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xff00B7BD)),
      ),
      child: DropdownButton<DateTime>(
        dropdownColor: widget.dropdownButtonColor ?? Colors.white,
        underline: const SizedBox.shrink(),
        icon: widget.dropdownIconWidget,
        iconSize: 20,
        isDense: true,
        padding: const EdgeInsets.all(4),
        value: widget.calendarController.selectedMonth,
        items: month.map<DropdownMenuItem<DateTime>>(
          (DateTime value) {
            return DropdownMenuItem<DateTime>(
              value: value,
              child: Text(
                '${DateFormat('MMMM', widget.locale).format(DateTime(value.year, value.month)).capitalize()} ${DateFormat('yyyy', widget.locale).format(DateTime(value.year, value.month))}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff00B7BD),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (DateTime? newValue) {
          widget.calendarController.selectMonth = newValue!;
          widget.onTimeChange?.call(widget.calendarController.selectedMonth);
        },
      ),
    );
  }

  Widget yearSelection(List<DateTime> year) {
    if (widget.onTapSwitchDateTime != null) {
      return GestureDetector(
        onTap: () async => await widget.onTapSwitchDateTime?.call(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xff00B7BD)),
          ),
          child: ListenableBuilder(
            listenable: widget.calendarController,
            builder: (_, __) {
              final value = widget.calendarController.selectedMonth;
              return Text(
                '${value.year}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff00B7BD),
                ),
              );
            },
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xff00B7BD)),
      ),
      child: DropdownButton<DateTime>(
        dropdownColor: widget.dropdownButtonColor ?? Colors.white,
        underline: const SizedBox.shrink(),
        icon: widget.dropdownIconWidget,
        iconSize: 20,
        isDense: true,
        padding: const EdgeInsets.all(4),
        value: widget.calendarController.selectedYear,
        items: year.map<DropdownMenuItem<DateTime>>(
          (DateTime value) {
            return DropdownMenuItem<DateTime>(
              value: value,
              child: Text(
                '${value.year}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff00B7BD),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (DateTime? newValue) {
          widget.calendarController.selectYear = newValue!;
          widget.onTimeChange?.call(widget.calendarController.selectedMonth);
        },
      ),
    );
  }

  Widget viewMode() => Switch(
        value:
            widget.calendarController.currentViewMode == ViewMode.compactMonth,
        onChanged: (_) {
          if (widget.calendarController.currentViewMode !=
              ViewMode.compactYear) {
            widget.calendarController.changeViewMode = ViewMode.compactYear;
          } else {
            widget.calendarController.changeViewMode = ViewMode.compactMonth;
          }
        },
      );

  Widget listViewCalendar() {
    return ListView.separated(
      controller: widget.scrollController,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      separatorBuilder: (_, __) =>
          SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: widget.calendarController.monthsInOption.length,
      itemBuilder: (context, index) {
        final month = widget.calendarController.monthsInOption[index];

        return childCollumn(month);
      },
    );
  }

  Widget scrollablePositionedListCalendar() {
    return ScrollablePositionedList.separated(
      itemScrollController: widget.calendarController.itemScrollController,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      separatorBuilder: (_, __) =>
          SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: widget.calendarController.monthsInOption.length,
      itemBuilder: (context, index) {
        final month = widget.calendarController.monthsInOption[index];

        return childCollumn(month);
      },
    );
  }

  Widget childCollumn(DateTime month) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: MonthWidget(
            cleanCalendarController: widget.calendarController,
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
                  childAspectRatio: widget.childAspectRationDay,
                  layout: widget.layout,
                  dayBuilder: widget.dayBuilder,
                  backgroundColor: widget.dayBackgroundColor,
                  selectedBackgroundColor: widget.daySelectedBackgroundColor,
                  selectedBackgroundColorBetween:
                      widget.daySelectedBackgroundColorBetween,
                  disableBackgroundColor: widget.dayDisableBackgroundColor,
                  dayDisableColor: widget.dayDisableColor,
                  radius: widget.dayRadius,
                  textStyle: widget.dayTextStyle,
                );
              },
            )
          ],
        )
      ],
    );
  }
}
