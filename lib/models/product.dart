import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id()
  int id = 0;

  /// name of the product
  String name;

  /// description of the product
  String? description;

  /// price of the product
  double price;

  /// time the product was created
  DateTime createdAt;

  Product({
    required this.name,
    required this.price,
    this.description,
  }) : createdAt = DateTime.now();
}
