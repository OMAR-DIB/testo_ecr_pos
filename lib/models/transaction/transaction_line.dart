import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/transaction/transaction.dart';


@Entity()
class TransactionLine {
  @Id()
  int id = 0;

  String itemName;
  int quantity;
  double price;

  // Optional: Link back to Transaction
  final ToOne<Transaction> transaction = ToOne<Transaction>();

  TransactionLine({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}
