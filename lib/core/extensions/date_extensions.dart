extension DateFormatting on DateTime {
  String formatAsDMY() {
    return "${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year";
  }
}
