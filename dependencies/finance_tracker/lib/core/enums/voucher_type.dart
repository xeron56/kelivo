// For this app, only Payment and Receipts are the voucher types planned and required.
enum VoucherType {
  payment("Payment"),
  receipt("Receipt");

  const VoucherType(this.label);
  final String label;
}
