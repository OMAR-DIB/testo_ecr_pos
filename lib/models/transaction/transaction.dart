import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/payment/payment.dart';
import 'package:testooo/models/transaction/transaction_line.dart';

@Entity() // Correct annotation
class Transaction {
  @Id()
  int id = 0;
  String transactionDate;
  bool isPaymentConfirmed;
  final lines = ToMany<TransactionLine>();

  Transaction({
    required this.transactionDate,
    this.isPaymentConfirmed = false,
  });
}