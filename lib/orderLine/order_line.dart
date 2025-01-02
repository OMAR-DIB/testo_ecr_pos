import 'package:objectbox/objectbox.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/utils/calculation_utils.dart';

// import '../../utils/calculation_utils.dart';
// import '../product/product.dart';

@Entity()
class OrderLine {
  /// Product id
  @Id()
  int id;

  /// Product
  ToOne<Product> product = ToOne<Product>();

  /// Quantity
  double quantity;

  // New discount field (specific to this order line)
  double discount;

  /// Constructor
  OrderLine({
    required this.id,
    required this.quantity,
    this.discount = 0.0,
  });

  /// two order lines are equal if they have the same product
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderLine && other.product.target == product.target;
  }

  @override
  int get hashCode => product.target.hashCode;

  /// String representation of the order line
  @override
  String toString() {
    return 'OrderLine{id: $id, productId: ${product.target!.id}, quantity: $quantity, discount: $discount}';
  }

  // Calculate the total price with discount
  double get total {
    double originalPrice = product.target!.price * quantity;
    double discountedPrice = originalPrice * (1 - discount / 100);
    return CalculationUtils.fixPrecision(discountedPrice, 2);
  }

  /// VAT amount of the order line
  double get vatAmount =>
      CalculationUtils.fixPrecision(quantity * product.target!.tva, 2);
}
