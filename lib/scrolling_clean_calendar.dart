library clean_scroll_calendar;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrolling_clean_calendar/to/month.dart';
import 'package:scrolling_clean_calendar/utils/date_utils.dart';

class CleanScrollCalendar extends StatefulWidget {
  CleanScrollCalendar({Key key}) : super(key: key);

  @override
  _CleanScrollCalendarState createState() => _CleanScrollCalendarState();
}

class _CleanScrollCalendarState extends State<CleanScrollCalendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dayWeekPtbr = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final dayWeekEn = ['Sun', 'Mon', 'Tue', 'Web', 'Thu', 'Fri', 'Sat'];

    final today = DateTime.now();

    final DateTime minDate = today;
    final DateTime maxDate = today.add(const Duration(days: 365));

    final months = DateUtils.extractWeeks(minDate, maxDate);

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMMM yyyy')
                        .format(DateTime(month.year, month.month)),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey[800],
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        for (var i = 0; i < DateTime.daysPerWeek; i++)
                          TableCell(
                            child: Center(
                              child: Text(
                                dayWeekEn[i],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    ...month.weeks.map(
                      (Week week) {
                        DateTime firstDay = week.firstDay;
                        bool rangeFeatureEnabled = false;

                        return TableRow(
                          children: List<Widget>.generate(DateTime.daysPerWeek,
                              (int position) {
                            DateTime day = DateTime(
                                week.firstDay.year,
                                week.firstDay.month,
                                firstDay.day +
                                    (position - (firstDay.weekday - 1)));

                            if ((position + 1) < week.firstDay.weekday ||
                                (position + 1) > week.lastDay.weekday ||
                                day.isBefore(minDate) ||
                                day.isAfter(maxDate)) {
                              return SizedBox.shrink();
                            } else {
                              return TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      DateFormat('d').format(day),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }, growable: false),
                        );
                      },
                    ).toList(growable: false),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
