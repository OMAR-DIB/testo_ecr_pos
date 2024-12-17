import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/transaction/transaction.dart';


@Entity()
class TransactionLine {
  @Id()
  int id = 0;
  String itemName;
  int quantity;
  double price;

  TransactionLine({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}