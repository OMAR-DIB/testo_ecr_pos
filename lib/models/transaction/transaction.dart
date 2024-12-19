import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction_line.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  String transactionDate;
  bool isPaymentConfirmed = false;
  
  
  // TransactionLines (One-to-Many)
  final ToMany<TransactionLine> lines = ToMany<TransactionLine>();

  // Payments (One-to-Many, saved after confirmation)
  final ToMany<Payment> payments = ToMany<Payment>();

  Transaction({required this.transactionDate});
}
