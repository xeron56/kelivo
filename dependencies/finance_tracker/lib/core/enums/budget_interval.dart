// Time Interval for a budget to be based on.
enum BudgetInterval {
  weekly(label: 'Weekly', singular: "Week"),
  monthly(label: 'Monthly', singular: "Month"),
  annual(label: 'Annual', singular: "Year"),
  ;

  final String label;
  final String singular;

  const BudgetInterval({required this.label, required this.singular});
}
