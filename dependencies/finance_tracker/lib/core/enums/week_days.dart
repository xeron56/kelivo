enum WeekDays {
  mon(label: "Monday", short: "Mon"),
  tue(label: "Tuesday", short: "Tue"),
  wed(label: "Wednsday", short: "Wed"),
  thu(label: "Thursday", short: "Thu"),
  fri(label: "Friday", short: "Fri"),
  sat(label: "Saturday", short: "Sat"),
  sun(label: "Sunday", short: "Sun"),
  ;

  final String label;
  final String short;

  const WeekDays({
    required this.label,
    required this.short,
  });

  int get weekday => index + 1;
}
