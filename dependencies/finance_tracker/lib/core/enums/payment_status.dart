enum PaymentStatus {
  pending('Pending'),
  paid('Paid'),
  cancelled('Cancelled'),
  overdue('Overdue'),
  ;

  const PaymentStatus(this.label);
  final String label;
}
