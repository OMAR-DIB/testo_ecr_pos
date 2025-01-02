import 'package:flutter/material.dart';
import 'package:testooo/main.dart';
import 'package:testooo/order/active_order_repo.dart';
import 'package:testooo/orderLine/order_line_repo.dart';
import 'package:testooo/provider/cart_provider.dart';
import 'package:uuid/uuid.dart';

class CartManager with ChangeNotifier {
  final Map<String, CartProvider> _carts = {};
  String? _activeCartId;

  // Getters
  List<String> get cartIds => _carts.keys.toList();
  CartProvider? get activeCart => _activeCartId != null ? _carts[_activeCartId] : null;

  // Create a new cart and set it as active
  void createNewCart() {
    final newCartId = Uuid().v4().substring(0,1);
    _carts[newCartId] = CartProvider(
      activeOrderBox: ActiveOrderRepo(gloablObx.store.box()), 
      orderLineRepo: OrderLineRepo(gloablObx.store.box()),
    );
    _activeCartId = newCartId;
    notifyListeners();
  }

  // Switch active cart
  void switchCart(String cartId) {
    if (_carts.containsKey(cartId)) {
      _activeCartId = cartId;
      notifyListeners();
    }
  }

  // Remove a cart
  void removeCart(String cartId) {
    _carts.remove(cartId);
    if (_activeCartId == cartId) {
      _activeCartId = _carts.isNotEmpty ? _carts.keys.first : null;
    }
    notifyListeners();
  }
}
