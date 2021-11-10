import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:scrollable_clean_calendar/utils/date_models.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class MonthWidget extends StatelessWidget {
  final Month month;
  final String locale;
  final Layout? layout;
  final Widget Function(BuildContext context, String month)? monthBuilder;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.locale,
    required this.layout,
    required this.monthBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = DateFormat('MMMM yyyy', locale)
        .format(DateTime(month.year, month.month));

    if (layout != null) {
      return <Layout, Widget Function()>{
        Layout.DEFAULT: () => _pattern(context, text),
        Layout.BEAUTY: () => _beauty(context, text)
      }[layout]!();
    }

    return monthBuilder!(context, text);
  }

  Widget _pattern(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text.capitalize(),
          style: Theme.of(context).textTheme.headline6!,
        ),
      ],
    );
  }

  Widget _beauty(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text.capitalize(),
          style: Theme.of(context).textTheme.headline6!,
        ),
      ],
    );
  }
}
