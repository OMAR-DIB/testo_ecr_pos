import 'package:testooo/main.dart';
import 'package:testooo/models/payment/payment.dart';
class PaymentRepo {
  final paymentBox = gloablObx.store.box<Payment>();

  PaymentRepo();

  // Create a new payment
  Payment createPayment({
    required double amount, 
    required String paymentType,
    bool isConfirmed = false,
  }) {
    return Payment(
      amount: amount, 
      paymentType: paymentType, 
      isConfirmed: isConfirmed
    );
  }

  // Save a payment
  int savePayment(Payment payment) {
    return paymentBox.put(payment);
  }

  // Get payment by ID
  Payment? getPaymentById(int paymentId) {
    return paymentBox.get(paymentId);
  }

  // Update payment status
  void updatePaymentStatus(int paymentId, bool isConfirmed) {
    final payment = paymentBox.get(paymentId);
    if (payment != null) {
      payment.isConfirmed = isConfirmed;
      paymentBox.put(payment);
    }
  }

  // Delete a payment
  void deletePayment(int paymentId) {
    paymentBox.remove(paymentId);
  }

  // Get all payments
  List<Payment> getAllPayments() {
    return paymentBox.getAll();
  }

  // Calculate total payment amount
  double calculateTotalPaymentAmount() {
    final payments = getAllPayments();
    return payments.fold(0, (total, payment) => total + payment.amount);
  }
}
