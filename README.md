# Scrollable clean calendar

A clean calendar widget with vertical scroll, locale, and range selection date.

## Instalation

Add `scrollable_clean_calendar: 0.5.1` in your `pubspec.yaml`.

## Locale

This calendar supports locales. To display the Calendar in desired language, use locale property. If you don't specify it, a default locale will be used.

Example `locale: 'pt'`

## Parameters

| Name                            | Required | Type      | description                                                                                                |
| ------------------------------- | -------- | --------- | ---------------------------------------------------------------------------------------------------------- |
| minDate                         | true     | DateTime  | initial calendar date                                                                                      |
| maxDate                         | true     | DateTime  | last calendar date                                                                                         |
| isRangeMode                         | false     | bool  | if you want to select two dates value should be true. "Default is true"                                                                                         |
| monthLabelAlign                         | false     | MainAxisAlignment  | Alignment of the Month text. "Default is MainAxisAlignment.center"                                                     |
| onRangeSelected                 | false    | Function  | return two date selected                                                                                   |
| onTapDate                       | false    | Function  | return the date selected                                                                                   |
| dayLabelStyle                   | false    | Function  | Function to determine style day label                                                                      |
| showDaysWeeks                   | false    | bool      | if false not show day of week label                                                                        |
| monthLabelStyle                 | false    | TextStyle | Style month label                                                                                          |
| dayWeekLabelStyle               | false    | TextStyle | Style day week label                                                                                       |
| selectedDateColor               | false    | Color     | Color is selected date                                                                                     |
| rangeSelectedDateColor          | false    | Color     | Color range of date selected                                                                               |
| selectDateRadius                | false    | double    | Apply radius when selected two dates                                                                       |
| renderPostAndPreviousMonthDates | false    | bool      | Show the dates of the first Month before the `minDate` and the dates of the last Month after the `maxDate` |
| disabledDateColor               | false    | Color     | Color of the disabled dates                                                                                |
| initialDateSelected             | false    | DateTime  | First date that is already selected when the calendar Init                                                 |
| endDateSelected                 | false    | DateTime  | Last date that is already selected when the calendar Init                                                  |

## Locale en

[![Simulator-Screen-Shot-i-Phone-11-2020-11-26-at-14-38-24.png](https://i.postimg.cc/8znFXH9h/Simulator-Screen-Shot-i-Phone-11-2020-11-26-at-14-38-24.png)](https://postimg.cc/mPC2tQbD)

## Locale pt

[![Simulator-Screen-Shot-i-Phone-11-2020-11-26-at-14-38-53.png](https://i.postimg.cc/PqpCgDn0/Simulator-Screen-Shot-i-Phone-11-2020-11-26-at-14-38-53.png)](https://postimg.cc/v1y89cBv)
