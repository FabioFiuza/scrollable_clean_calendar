import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/src/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/utils/date_models.dart';
import 'package:scrollable_clean_calendar/src/week_helper.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class DaysWidget extends StatelessWidget {
  final CleanCalendarController cleanCalendarController;
  final Month month;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final Layout? layout;
  final Widget Function(
    BuildContext context, {
    required DateTime day,
    required String text,
    required bool isSelected,
  })? dayBuilder;

  const DaysWidget({
    Key? key,
    required this.month,
    required this.cleanCalendarController,
    required this.calendarCrossAxisSpacing,
    required this.calendarMainAxisSpacing,
    required this.layout,
    required this.dayBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final x = ((cleanCalendarController.startWeekDay - DateTime.daysPerWeek) -
            DateTime(month.year, month.month).weekday)
        .abs();

    final int start = x == 7 ? 0 : x;

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisSpacing: this.calendarCrossAxisSpacing,
      mainAxisSpacing: this.calendarMainAxisSpacing,
      shrinkWrap: true,
      children: List.generate(month.daysInMonth + start, (index) {
        if (index < start) return const SizedBox.shrink();
        final day = DateTime(month.year, month.month, (index + 1 - start));
        final text = (index + 1 - start).toString();

        bool isSelected = false;

        if (cleanCalendarController.rangeMinDate != null) {
          if (cleanCalendarController.rangeMinDate != null &&
              cleanCalendarController.rangeMaxDate != null) {
            isSelected = day
                    .isSameDayOrAfter(cleanCalendarController.rangeMinDate!) &&
                day.isSameDayOrBefore(cleanCalendarController.rangeMaxDate!);
          } else {
            isSelected =
                day.isAtSameMomentAs(cleanCalendarController.rangeMinDate!);
          }
        }

        Widget widget;

        if (layout != null) {
          widget = <Layout, Widget Function()>{
            Layout.DEFAULT: () =>
                _pattern(context, day: day, isSelected: isSelected, text: text),
            Layout.BEAUTY: () =>
                _beauty(context, day: day, isSelected: isSelected, text: text),
          }[layout]!();
        } else {
          widget = dayBuilder!(context,
              day: day, isSelected: isSelected, text: text);
        }

        return GestureDetector(
          onTap: () {
            cleanCalendarController.onDayClick(day);
          },
          child: widget,
        );
      }),
    );
  }

  Widget _pattern(
    BuildContext context, {
    required DateTime day,
    required String text,
    required bool isSelected,
  }) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).colorScheme.onSurface);

    if (isSelected) {
      if ((cleanCalendarController.rangeMinDate != null &&
              day.isSameDay(cleanCalendarController.rangeMinDate!)) ||
          (cleanCalendarController.rangeMaxDate != null &&
              day.isSameDay(cleanCalendarController.rangeMaxDate!))) {
        backgroundColor = Theme.of(context).colorScheme.primary;
        textStyle = Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary);
      } else {
        backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(.3);
        textStyle = Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).colorScheme.primary);
      }
    } else if (day.isSameDay(cleanCalendarController.minDate)) {
      backgroundColor = Colors.transparent;
      textStyle = Theme.of(context)
          .textTheme
          .bodyText1!
          .copyWith(color: Theme.of(context).colorScheme.primary);
    } else if (day.isBefore(cleanCalendarController.minDate) ||
        day.isAfter(cleanCalendarController.maxDate)) {
      backgroundColor = Theme.of(context).colorScheme.surface.withOpacity(.4);
      textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
            decoration: TextDecoration.lineThrough,
          );
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: day.isSameDay(cleanCalendarController.minDate)
            ? Border.all(color: Colors.indigo, width: 2)
            : null,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }

  Widget _beauty(
    BuildContext context, {
    required DateTime day,
    required String text,
    required bool isSelected,
  }) {
    BorderRadiusGeometry? borderRadius;
    Color backgroundColor = Colors.transparent;
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).colorScheme.onSurface);

    if (isSelected) {
      if ((cleanCalendarController.rangeMinDate != null &&
              day.isSameDay(cleanCalendarController.rangeMinDate!)) ||
          (cleanCalendarController.rangeMaxDate != null &&
              day.isSameDay(cleanCalendarController.rangeMaxDate!))) {
        backgroundColor = Theme.of(context).colorScheme.primary;
        textStyle = Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary);

        if (cleanCalendarController.rangeMinDate != null &&
            day.isSameDay(cleanCalendarController.rangeMinDate!)) {
          borderRadius = BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          );
        } else if (cleanCalendarController.rangeMaxDate != null &&
            day.isSameDay(cleanCalendarController.rangeMaxDate!)) {
          borderRadius = BorderRadius.only(
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6),
          );
        }
      } else {
        backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(.3);
        textStyle = Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).colorScheme.primary);
      }
    } else if (day.isSameDay(cleanCalendarController.minDate)) {
    } else if (day.isBefore(cleanCalendarController.minDate) ||
        day.isAfter(cleanCalendarController.maxDate)) {
      textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
            decoration: TextDecoration.lineThrough,
          );
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }
}
