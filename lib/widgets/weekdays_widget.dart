import 'package:flutter/material.dart';

import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class WeekdaysWidget extends StatelessWidget {
  final bool showWeekdays;
  final CleanCalendarController cleanCalendarController;
  final String locale;
  final Layout? layout;
  final TextStyle? textStyle;
  final Widget Function(BuildContext context, String weekDay)? weekDayBuilder;

  const WeekdaysWidget({
    Key? key,
    required this.showWeekdays,
    required this.cleanCalendarController,
    required this.locale,
    required this.layout,
    required this.weekDayBuilder,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showWeekdays) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(DateTime.daysPerWeek, (index) {
        final weekDay = cleanCalendarController.getDaysOfWeek(locale)[index];

        if (weekDayBuilder != null) {
          return weekDayBuilder!(context, weekDay);
        }

        return <Layout, Widget Function()>{
          Layout.DEFAULT: () => _pattern(context, weekDay),
          Layout.BEAUTY: () => _beauty(context, weekDay)
        }[layout]!();
      }),
    );
  }

  Widget _pattern(BuildContext context, String weekDay) {
    return Center(
      child: Text(
        weekDay.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }

  Widget _beauty(BuildContext context, String weekDay) {
    return Center(
      child: Text(
        weekDay.capitalize(),
        style: textStyle ??
            Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(.4),
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}
