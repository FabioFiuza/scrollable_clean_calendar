# Scrollable clean calendar

A clean widget calendar with vertical scroll, locale, and range selection date.

## Instalation

Add `scrollable_clean_calendar: 0.1.0` in your `pubspec.yaml`.

## Locale

This calendar supports locales. To display the Calendar in desired language, use locale property. If you don't specify it, a default locale will be used.

Example `locale: 'pt'`

## Parameters

| Name                   | Required | Type      | description                           |
| ---------------------- | -------- | --------- | ------------------------------------- |
| minDate                | true     | DateTime  | initial calendar date                 |
| maxDate                | true     | DateTime  | last calendar date                    |
| onRangeSelected        | false    | Function  | return two date selected              |
| onTapDate              | false    | Function  | return the date selected              |
| dayLabelStyle          | false    | Function  | Function to determine style day label |
| showDaysWeeks          | false    | bool      | if false not show day of week label   |
| monthLabelStyle        | false    | TextStyle | Style month label                     |
| dayWeekLabelStyle      | false    | TextStyle | Style day week label                  |
| selectedDateColor      | false    | Color     | Color is selected date                |
| rangeSelectedDateColor | false    | Color     | Color range of date selected          |
| selectDateRadius       | false    | double    | Apply radius when selected two dates  |

## Locale en

[![Captura-de-Tela-2020-10-28-a-s-22-03-12.png](https://i.postimg.cc/VkJn9MxV/Captura-de-Tela-2020-10-28-a-s-22-03-12.png)](https://postimg.cc/BjGj48QT)

## Locale pt

[![Captura-de-Tela-2020-10-28-a-s-21-40-18.png](https://i.postimg.cc/nzjP6C9R/Captura-de-Tela-2020-10-28-a-s-21-40-18.png)](https://postimg.cc/G8RKD3QG)
