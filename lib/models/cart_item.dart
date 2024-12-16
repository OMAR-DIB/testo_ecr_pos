import 'package:testooo/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  double discount;  // Discount percentage for this item

  CartItem({required this.product, required this.quantity, this.discount = 0});

  double get totalPrice {
    double price = product.price * quantity;
    double discountedPrice = price * (1 - (discount / 100));
    return discountedPrice;
  }
}
