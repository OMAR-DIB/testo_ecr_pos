import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/product.dart';
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
  
  /// Link to the product to access its TVA
  final ToOne<Product> product = ToOne<Product>();


  TransactionLine({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}
