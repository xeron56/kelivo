// Date filter types for transactions
enum DateFilterType {
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly'),
  custom('Custom'),
  annual('Annual'),
  ;

  const DateFilterType(this.label);
  final String label;
}
