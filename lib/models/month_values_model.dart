class MonthValues {
  /// The current day in layout
  final DateTime month;

  /// The text (day)
  final String text;

  /// If the item is select or not
  final bool isSelected;

  MonthValues({
    required this.month,
    required this.text,
    required this.isSelected,
  });
}
