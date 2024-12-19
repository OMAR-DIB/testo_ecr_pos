import 'package:testooo/main.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction.dart';
import 'package:testooo/models/transaction/transaction_line.dart';
import 'package:testooo/models/cart_item.dart';
import 'package:objectbox/objectbox.dart';

class TransactionRepo {
  final transactionBox = gloablObx.store.box<Transaction>();
  final paymentBox = gloablObx.store.box<Payment>();

  TransactionRepo();

  // CRUD Operations
  Transaction? getTransaction(int id) => transactionBox.get(id);
  List<Transaction> getAllTransactions() => transactionBox.getAll();
  int saveTransaction(Transaction transaction) => transactionBox.put(transaction);
  void deleteTransaction(int id) => transactionBox.remove(id);

  Payment? getPayment(int id) => paymentBox.get(id);
  int savePayment(Payment payment) => paymentBox.put(payment);
  void deletePayment(int id) => paymentBox.remove(id);
}
