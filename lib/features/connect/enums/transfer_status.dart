enum TransferStatus {
  idle(0),
  inProgress(1),
  success(2),
  failed(3);

  final int value;

  const TransferStatus(this.value);

  factory TransferStatus.fromValue(
    int value, {
    TransferStatus fallback = TransferStatus.idle,
  }) {
    return TransferStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => fallback,
    );
  }
}
