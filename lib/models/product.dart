import 'package:objectbox/objectbox.dart';
@Entity()
class Product {
  @Id()
  int id = 0;

  /// Name of the product
  String name;

  /// Description of the product
  String? description;

  /// Price of the product
  double price;

  /// Time the product was created
  DateTime createdAt;

  Product({
    required this.name,
    required this.price,
    this.description,
  }) : createdAt = DateTime.now();

  /// Override `hashCode` using `id`
  @override
  int get hashCode => id.hashCode;

  /// Override `==` for object comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Product) return false;
    return other.id == id;
  }
}
