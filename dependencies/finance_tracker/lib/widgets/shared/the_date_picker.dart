import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TheDatePicker extends StatelessWidget {
  /// A date picker field
  const TheDatePicker({
    super.key,
    required this.initialDate,
    required this.onChanged,
    required this.label,
    this.needTime = true,
    this.errorText,
    this.firstDate,
    this.lastDate,
    this.datePattern = "yyyy-MM-dd",
    this.timePattern = "hh:mm a",
  });

  /// Field intial date
  final DateTime? initialDate;

  /// Callback function on date is changed
  final Function(DateTime) onChanged;

  /// Label for the field
  final String label;

  /// Text to show in case of an error
  final String? errorText;

  /// Whether the user need to select the time with date
  final bool needTime;

  /// DatePickerDialog firstDate
  final DateTime? firstDate;

  /// DatePickerDialog lastDate
  final DateTime? lastDate;

  /// The app date pattern
  final String datePattern;

  /// The app time pattern
  final String timePattern;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat(datePattern);
    final DateFormat timeFormat = DateFormat(timePattern);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
        errorText: errorText,
      ),
      textAlign: initialDate != null ? TextAlign.center : TextAlign.start,
      controller: TextEditingController(
        text: initialDate == null
            ? "Select Date"
            : needTime
                ? "${dateFormat.format(initialDate ?? now)}, ${timeFormat.format(initialDate ?? now)}"
                : dateFormat.format(initialDate ?? now),
      ),
      onTap: () async {
        DateTime? dt = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2101),
        );
        if (dt != null && context.mounted && needTime) {
          TimeOfDay? tm = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                  hour: initialDate?.hour ?? now.hour,
                  minute: initialDate?.minute ?? now.minute));

          if (tm != null) {
            dt = DateTime(dt.year, dt.month, dt.day, tm.hour, tm.minute);
            onChanged(dt);
          } else {
            dt = DateTime(dt.year, dt.month, dt.day);
            onChanged(dt);
          }
        }
        if (dt != null) {
          onChanged(dt);
        }
      },
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
