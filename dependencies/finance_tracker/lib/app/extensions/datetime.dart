// Additional functions for DateTime.
extension DateTimeExtension on DateTime? {
  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs ||
          date.isAfter(dateTime.copyWith(hour: 0, minute: 0, second: 0));
    }
    return false;
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs ||
          date.isBefore(dateTime.copyWith(hour: 23, minute: 59, second: 59));
    }
    return false;
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime);
      final isBefore = date.isBeforeOrEqualTo(toDateTime);
      return isAfter && isBefore;
    }
    return false;
  }

  bool isSameDayAs(DateTime dateTime) {
    final date = this;
    if (date != null) {
      return (dateTime.day == date.day &&
          dateTime.month == date.month &&
          dateTime.year == date.year);
    }
    return false;
  }
}
