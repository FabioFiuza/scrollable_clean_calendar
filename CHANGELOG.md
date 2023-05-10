## [1.4.1] - 2023-05-10

- Changed the intl dependency declaration to use the intl version locked by flutter_localizations from sdk which fix incompatibility with updated Flutter 3.10 projects
- Fixed some deprecation warnings on more recent Flutter versions
- Bumped min Flutter version to 3.3.0 due to the deprecation warnigs fix

## [1.4.0] - 2022-07-20

- Add again the scrollController parameter as Optional (But remember, if you use this controller the Parameter `initialFocusDate` and the Functions `scrollToMonth` and `jumpToMonth` won't work since this override the scrollable list controller. Do not use them together or you will receive a nullPointer Exception)

## [1.3.1] - 2022-07-20

- Updated flutter_lints and moved it from direct dependency to dev dependency which fix incompatibility with updated Flutter 3 projects

## [1.3.0] - 2022-07-04 (**Breakchanges**)

- Remove property `scrollController`.
- Add property `initialFocusDate` inside `CleanCalendarController`.
- Add function `scrollToMonth` and `jumpToMonth` inside `CleanCalendarController`, now can scroll to specific month.

## [1.2.0] - 2022-04-28

- Create property `dayDisableColor`, so the color of the day when it is disabled could be customized

## [1.1.0] - 2022-03-13

- Create `readOnly` property inside `CleanCalendarController`, so the CalendarWidget can have the means to become a Read Only Widget

## [1.0.1] - 2021-12-23

- Now the method onDayTapped and onRangeSelected will just be activate when the user tapped the date

## [1.0.0] - 2021-11-19 (**Breakchanges**)

- Now we are in the version 1.0.0. We have a lot of different things:
  - Differents layout
  - Customizable widgets
  - Removing setState and using change notifier
  - Disabled dates before min date and after max date
  - Weekday start, in what weekday the calendar is going to start

## [0.5.2] - 2021-09-13

- Fix Date format in languages that have a more complex variation like Polish.

## [0.5.1] - 2021-09-13

- Minor fix in ScrollController
- Fix in setState() on initState

## [0.5.0] - 2021-09-13

- Add option to use calendar without date range, with only one date

## [0.4.0] - 2021-03-09

- Add Support to Flutter 2.
- Removing old dependencies.

## [0.3.0] - 2020-11-26

- Fixed a bug that the End Date could not be the same as de Initial Date.
- Added the possibility to open the calendar with dates already selected (One date, two dates, or none).

## [0.2.0] - 2020-11-25

- Added the possibility to show disabled dates the First and Last Month, these dates are the dates that are previous `minDate` and post `maxDate`.
- Fix a bug that the next Month displayed with empty values when the `maxDate` occurs on the last week of the month.

## [0.1.1] - 2020-10-28

- Fix bug day not rendering right.
- Fix calendar init in the Monday (future version change to the generic start someday of the week).

## [0.1.0] - 2020-10-21

- Added calendar full page with a scroll in the vertical.
- Added a select a range date with special colors.
- Added capture of the date selected.
- Change calendar with Locale.
