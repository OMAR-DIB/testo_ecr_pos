import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/transaction/transaction.dart';

@Entity( )
class Payment {
  @Id()
  int id = 0;
  String paymentType; // e.g., 'cash', 'card'
  double amount;      // Amount paid
  bool isConfirmed;

  Payment({
    required this.paymentType,
    required this.amount,
    this.isConfirmed = false,
  });
}

