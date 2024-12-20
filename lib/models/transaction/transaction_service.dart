import 'package:testooo/models/cart_item.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction.dart';
import 'package:testooo/models/transaction/transaction_line.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';

class TransactionService {
  final TransactionRepo _transactionRepo;

  TransactionService(this._transactionRepo);

  late Transaction _transaction; // Current transaction
  final List<Payment> _payments = []; // Holds all payments

  // Initialize Transaction from Cart Items
  void initializeTransaction(List<CartItem> cartItems) {
    _transaction = Transaction(transactionDate: DateTime.now().toIso8601String());
    for (var cartItem in cartItems) {
      final transactionLine = TransactionLine(
        itemName: cartItem.product.name,
        quantity: cartItem.quantity,
        price: cartItem.subPriceAfterTva,
      );
      _transaction.lines.add(transactionLine);
    }
  }

  // Calculate Total Price from Cart Items
  double calculateTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.subPriceAfterTva);
  }

  // Calculate Remaining Amount
  double calculateRemainingAmount(double totalAmount) {
    double totalPaid = _payments.fold(0.0, (sum, payment) => sum + payment.amount);
    return totalAmount - totalPaid;
  }

  // Add Payment to the List
  String addPayment(double amount, String paymentType, double totalAmount) {
  if (amount <= 0) return 'Amount must be greater than 0';

  // Check if the payment type already exists
  final existingPaymentIndex =
      payments.indexWhere((payment) => payment.paymentType == paymentType);

  if (existingPaymentIndex != -1) {
    // Update the existing payment's amount
    payments[existingPaymentIndex].amount += amount;
  } else {
    // Add a new payment if it doesn't exist
    payments.add(Payment(paymentType: paymentType, amount: amount));
  }

  // Calculate total paid so far
  final totalPaid = payments.fold(0.0, (sum, payment) => sum + payment.amount);
  if (totalPaid > totalAmount) {
    // Rollback the addition if it exceeds totalAmount
    if (existingPaymentIndex != -1) {
      payments[existingPaymentIndex].amount -= amount;
    } else {
      payments.removeLast();
    }
    return 'Total payment exceeds the required amount';
  }

  return ''; // Return no error if successful
}


  // Save Transaction with Payments
  int saveTransactionWithPayments() {
    // Save each payment to the database using the repo
    for (var payment in _payments) {
      final paymentId = _transactionRepo.savePayment(payment);
      _transaction.payments.add(payment);
      print('Payment saved with ID: $paymentId and Type: ${payment.paymentType}');
    }

    // Save the transaction
    final transactionId = _transactionRepo.saveTransaction(_transaction);
    print('Transaction saved with ID: $transactionId');
    return transactionId;
  }
  // Confirm Payments for a Transaction
  String confirmTransaction() {
    print('--- Confirming Transaction and Payments ---');
    // Check if all amounts are paid
    double remainingAmount = calculateRemainingAmount(
        _transaction.lines.fold(0.0, (sum, line) => sum + line.price));

    if (remainingAmount > 0) {
      return 'Remaining balance must be paid before confirming.';
    }

    // Confirm all payments and transaction
    for (var payment in _transaction.payments) {
      payment.isConfirmed = true;
      _transactionRepo.savePayment(payment);
      print('Payment confirmed -> ID: ${payment.id} | Type: ${payment.paymentType} | Amount: ${payment.amount}');
    }

    _transaction.isPaymentConfirmed = true;
    _transactionRepo.saveTransaction(_transaction);

    print('Transaction confirmed -> ID: ${_transaction.id}');
    print('--- Confirmation Complete ---');

    return ''; // Success
  }
  // Retrieve Payments List
  List<Payment> get payments => _payments;

  // Get the Transaction (useful for debugging or display)
  Transaction get transaction => _transaction;
}
