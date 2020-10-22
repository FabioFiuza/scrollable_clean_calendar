# Scrollable clean Calendar

A clean widget calendar with vertical scroll, locale, and range selection date.

## Instalation

Add `scrollable_clean_calendar: 0.1.0` in your `pubspec.yaml`.

## Locale

This calendar supports locales. To display the Calendar in desired language, use locale property. If you don't specify it, a default locale will be used.

Example `locale: 'pt'`

## Parameters

| Name                   | Required | description                          |
| ---------------------- | -------- | ------------------------------------ |
| minDate                | true     | initial calendar date                |
| maxDate                | true     | last calendar date                   |
| onRangeSelected        | false    | return two date selected             |
| showDaysWeeks          | false    | if false not show day of week label  |
| monthLabelStyle        | false    | Style month label                    |
| dayLabelStyle          | false    | Style day label                      |
| dayWeekLabelStyle      | false    | Style day week label                 |
| selectedDateColor      | false    | Color is selected date               |
| rangeSelectedDateColor | false    | Color range of date selected         |
| selectDateRadius       | false    | Apply radius when selected two dates |

[![scrollable calendar](https://i.postimg.cc/KzmYKLnC/Captura-de-Tela-2020-10-21-a-s-21-32-54.png)](https://postimg.cc/Lq0SwJQV)
