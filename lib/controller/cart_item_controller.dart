import 'package:testooo/models/cart_item.dart';
import 'package:testooo/models/product.dart';
import 'package:flutter/material.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/repo/product_repo.dart';

class CartItemController extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  double get totalPrice {
    final total = _cartItems.fold(
      0.0,
      (sum, item) => sum + item.subPriceAfterTva,
    );
    return total;                                 
  }

  // double get totalPriceafterTva {
  //   final total = _cartItems.fold(
  //     0.0,
  //     (sum, item) => sum + (totalPrice + item.gettva));
  //   return total;
  // }
//   double get subPriceAfterTva {
//   double basePrice = (product.price ) * quantity; // Calculate base price
//   double discountedPrice = basePrice * (1 - discount / 100); // Apply discount
//   double priceAfterTva = discountedPrice + gettva ; // Apply TVA
//   return priceAfterTva;
// }

  void dismissProduct(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void updateDiscount(Product product, double discount) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].discount = discount;
      notifyListeners();
    }
  }

  void openActionDrawer(BuildContext context, CartItem cartItem,
      CartItemController cartItemController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Row'),
              onTap: () {
                cartItemController.removeProduct(cartItem.product);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Discount'),
              onTap: () {
                // Example: Add edit functionality
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
