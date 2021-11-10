import 'package:flutter/material.dart';

import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class WeekDaysWidget extends StatelessWidget {
  final bool showDaysWeeks;
  final CleanCalendarController cleanCalendarController;
  final String locale;
  final Layout? layout;
  final Widget Function(BuildContext context, String weekDay)? weekDayBuilder;

  const WeekDaysWidget({
    Key? key,
    required this.showDaysWeeks,
    required this.cleanCalendarController,
    required this.locale,
    required this.layout,
    required this.weekDayBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showDaysWeeks) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(DateTime.daysPerWeek, (index) {
        final weekDay = cleanCalendarController.getDaysOfWeek(locale)[index];

        if (layout != null) {
          return <Layout, Widget Function()>{
            Layout.DEFAULT: () => _pattern(context, weekDay),
            Layout.BEAUTY: () => _beauty(context, weekDay)
          }[layout]!();
        }

        return weekDayBuilder!(context, weekDay);
      }),
    );
  }

  Widget _pattern(BuildContext context, String weekDay) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          weekDay.capitalize(),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(.4),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _beauty(BuildContext context, String weekDay) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          weekDay.capitalize(),
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(.4),
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
