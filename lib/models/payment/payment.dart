import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/transaction/transaction.dart';


@Entity()
class Payment {
  @Id()
  int id = 0;
  double amount;
  String paymentMethod;
  bool isConfirmed;

  Payment({
    required this.amount,
    required this.paymentMethod,
    this.isConfirmed = false,
  });
}
