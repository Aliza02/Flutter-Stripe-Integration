enum PaymentStatus { initial, loading, success, error }

abstract class PaymentEvent {}

class ProcessPayment extends PaymentEvent {
  // final String amount;
  // final String currency;
  // final String paymentMethod;
  // final String message;
  ProcessPayment(
    // required this.amount,
    // required this.currency,
    // required this.message,
    // required this.paymentMethod,
  );
}
