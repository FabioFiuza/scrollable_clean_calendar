import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/month_values_model.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class MonthWidget extends StatelessWidget {
  final DateTime month;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final MonthBuilder monthBuilder;
  final CleanCalendarController cleanCalendarController;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.locale,
    required this.layout,
    required this.monthBuilder,
    required this.textStyle,
    required this.textAlign,
    required this.cleanCalendarController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        '${DateFormat('MMMM', locale).format(DateTime(month.year, month.month)).capitalize()} ${DateFormat('yyyy', locale).format(DateTime(month.year, month.month))}';

    bool isSelected =
        cleanCalendarController.selectedMonth.month == month.month;
    final monthValues = MonthValues(
      month: month,
      text: text,
      isSelected: isSelected,
    );

    if (monthBuilder != null) {
      return monthBuilder!(context, monthValues);
    }

    return <Layout, Widget Function()>{
      Layout.DEFAULT: () => _pattern(context, text),
      Layout.BEAUTY: () => _beauty(context, text)
    }[layout]!();
  }

  Widget _pattern(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.titleLarge!,
    );
  }

  Widget _beauty(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.titleLarge!,
    );
  }
}
