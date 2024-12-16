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
    final subtotal = _cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    return subtotal;
  }

  void dismissProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }
  
  void addProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
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
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].discount = discount;
      notifyListeners();
    }
  }
}
