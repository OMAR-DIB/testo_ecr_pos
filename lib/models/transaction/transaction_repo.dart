import 'package:testooo/main.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction.dart';
import 'package:testooo/models/transaction/transaction_line.dart';
import 'package:testooo/models/cart_item.dart';
import 'package:objectbox/objectbox.dart';

class TransactionRepo {
  // final paymentBox = gloablObx.store.box<Payment>();
  final transactionBox = gloablObx.store.box<Transaction>();

  TransactionRepo();

  // Create a transaction from cart items
  Transaction createTransactionFromCartItems(List<CartItem> cartItems) {
    final transaction =
        Transaction(transactionDate: DateTime.now().toIso8601String());

    for (var cartItem in cartItems) {
      final transactionLine = TransactionLine(
        itemName: cartItem.product.name,
        quantity: cartItem.quantity,
        price: cartItem.subPrice,
      );
      transaction.lines.add(transactionLine);
    }

    return transaction;
  }

  // Save the transaction with unconfirmed payment
  int saveTransaction(Transaction transaction) {
    // Ensure payment links back to this transaction
    
    // Save the transaction (unconfirmed)
    final transactionId = transactionBox.put(transaction);
    print('Transaction saved with ID: $transactionId (Payment unconfirmed)');
    return transactionId;
  }

  // Confirm payment and update the transaction status
  void confirmPayment(int transactionId) {
    final transaction = transactionBox.get(transactionId);

    if (transaction == null) {
      print('Error: Transaction not found!');
      return;
    }

    // // Ensure payment is confirmed
    // for (var payment in transaction.payments) {
    //   payment.isConfirmed = true;
    //   paymentBox.put(payment); // Update the payment in ObjectBox
    // }

    transaction.isPaymentConfirmed = true;
    transactionBox.put(transaction); // Update transaction status
    print('Transaction confirmed and saved!');
  }
}