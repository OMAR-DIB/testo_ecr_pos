import 'package:flutter/material.dart';
import 'package:testooo/constant/order_mode.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/order/active_order.dart';
import 'package:testooo/order/active_order_repo.dart';
import 'package:testooo/orderLine/order_line.dart';
import 'package:testooo/orderLine/order_line_repo.dart';



class CartProvider extends ChangeNotifier {
  /// Active orders repository
  final ActiveOrderRepo _activeOrderBox;

  /// Order Lines repository
  final OrderLineRepo _orderLineRepo;

  /// List of active orders
  List<ActiveOrder> orders = [];
  int _currentCartIndex = 0;

  ActiveOrder? get currentCart => 
      orders.isNotEmpty ? orders[_currentCartIndex] : null;

  ActiveOrder? get savedOrder => orders.isNotEmpty 
      ? orders[_currentCartIndex] 
      : null;

  CartProvider({
    required ActiveOrderRepo activeOrderBox,
    required OrderLineRepo orderLineRepo,
  })  : _activeOrderBox = activeOrderBox,
        _orderLineRepo = orderLineRepo {
    _refreshOrders();
  }

  void _refreshOrders() {
    orders = _activeOrderBox.getActiveOrdersByMode(OrderMode.delivery);
    if (orders.isEmpty) {
      _addNewCart(); // Create a new cart if none exist
    }
    notifyListeners();
  }

  void _addNewCart() {
    final newCart = ActiveOrder(
      mode: OrderMode.delivery.name,
      
    );
    orders.add(newCart);
    _activeOrderBox.insertActiveOrder(newCart);
    _currentCartIndex = orders.length - 1; // Set the new cart as current
    notifyListeners();
  }

  void switchCart(int index) {
    if (index >= 0 && index < orders.length) {
      _currentCartIndex = index;
      notifyListeners(); // Notify listeners to refresh the UI
    }
  }

  void addOrder(Product product) {
    if (currentCart == null) return;

    // Check if the item already exists in the current cart
    int index = findProductIndex(product);
    
    if (index >= 0) {
      // If item exists, increase quantity
      currentCart!.orderLines[index].quantity += 1;
      _orderLineRepo.insertOrderLine(currentCart!.orderLines[index]);
    } else {
      // If item doesn't exist, create a new order line
      final newOrderLine = OrderLine(id: 0, quantity: 1);
      newOrderLine.product.target = product;
      currentCart!.orderLines.add(newOrderLine);

      // Insert the selected order
      _activeOrderBox.insertActiveOrder(currentCart!);
    }

    notifyListeners(); // Notify listeners to refresh the UI
  }

  void removeOrderLine(Product product) {
    if (currentCart == null) return;

    int index = findProductIndex(product);

    if (index >= 0) {
      if (currentCart!.orderLines[index].quantity > 1) {
        // Decrease quantity if greater than 1
        currentCart!.orderLines[index].quantity -= 1;
      } else {
        // Remove the order line if quantity is 1
        _orderLineRepo.deleteOrderLine(currentCart!.orderLines[index]);
        currentCart!.orderLines.removeAt(index);
      }
    }

    notifyListeners(); // Notify listeners to refresh the UI
  }

  void removeOrder() {
    if (currentCart != null) {
      _activeOrderBox.deleteActiveOrder(currentCart!);
      orders.removeAt(_currentCartIndex);
      _currentCartIndex = orders.isNotEmpty ? 0 : -1; // Reset index if no carts left
      notifyListeners();
    }
  }

  int findProductIndex(Product product) {
    return currentCart?.orderLines
            .indexWhere((element) => element.product.target!.id == product.id) ??
        -1;
  }

  double productQuantity(Product product) {
    if (currentCart == null) return 0;

    int index = findProductIndex(product);
    return index >= 0 ? currentCart!.orderLines[index].quantity : 0;
  }

  void createNewOrder() {
    _addNewCart();
  }
}