import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/month_values_model.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class MonthCompactView extends StatelessWidget {
  final DateTime month;
  final CleanCalendarController cleanCalendarController;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final MonthBuilder monthBuilder;
  final double childAspectRatio;

  const MonthCompactView({
    Key? key,
    required this.month,
    required this.locale,
    this.layout,
    required this.monthBuilder,
    this.textStyle,
    this.textAlign,
    required this.childAspectRatio,
    required this.cleanCalendarController,
    required this.calendarCrossAxisSpacing,
    required this.calendarMainAxisSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 4,
        childAspectRatio: childAspectRatio,
        physics: const NeverScrollableScrollPhysics(),
        addRepaintBoundaries: false,
        padding: EdgeInsets.zero,
        crossAxisSpacing: calendarCrossAxisSpacing,
        mainAxisSpacing: calendarMainAxisSpacing,
        shrinkWrap: true,
        children: cleanCalendarController.months.map(
          (month) {
            bool isSelected = this.month.month == month.month;
            final monthValues = MonthValues(
              month: month,
              text: DateFormat('MMM', locale).format(month).capitalize(),
              isSelected: isSelected,
            );
            return monthBuilder!(context, monthValues);
          },
        ).toList(),
      );
}
