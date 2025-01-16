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

  /// Index of the current cart in the orders list
  int _currentCartIndex = 0;

  /// Gets the last index of the orders list
  int get lastIndex => orders.length - 1;

  /// Gets the current cart if it exists, otherwise null
  ActiveOrder? get currentCart =>
      orders.isNotEmpty ? orders[_currentCartIndex] : null;

  /// CartProvider constructor
  CartProvider({
    required ActiveOrderRepo activeOrderBox,
    required OrderLineRepo orderLineRepo,
  })  : _activeOrderBox = activeOrderBox,
        _orderLineRepo = orderLineRepo {
    _refreshOrders();
  }

  /// Refreshes the list of active orders and creates a new cart if none exist
  void _refreshOrders() {
    orders = _activeOrderBox.getActiveOrdersByMode(OrderMode.delivery);
    if (orders.isEmpty) {
      _addNewCart(); // Create a new cart if none exist
    }
    notifyListeners();
  }

  /// Adds a new cart to the orders list
  void _addNewCart() {
    final newCart = ActiveOrder(
      mode: OrderMode.delivery.name,
    );
    orders.add(newCart);
    _activeOrderBox.insertActiveOrder(newCart);
    _currentCartIndex = orders.length - 1; // Set the new cart as current
    notifyListeners();
  }

  /// Switches the current cart to the cart at the specified index
  void switchCart(int index) {
    if (index >= 0 && index < orders.length && index != _currentCartIndex) {
      _currentCartIndex = index;
      notifyListeners(); // Notify listeners to refresh the UI
    }
  }

  /// Adds a product to the current cart
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

  /// Removes all the order lines (products) from the current cart
  void removeOrderLine(Product product) {
    if (currentCart == null) return;

    int index = findProductIndex(product);

    if (index >= 0) {
      // Collect all order lines for the product
      List<OrderLine> linesToRemove = currentCart!.orderLines
          .where((orderLine) => orderLine.product.target!.id == product.id)
          .toList();

      // Remove each order line using the repository
      for (var orderLine in linesToRemove) {
        _orderLineRepo.deleteOrderLine(orderLine);
        currentCart!.orderLines.remove(orderLine);
      }
    }

    notifyListeners(); // Notify listeners to refresh the UI
  }

  /// Finds the index of a product in the current cart's order lines
  int findProductIndex(Product product) {
    return currentCart?.orderLines.indexWhere(
            (element) => element.product.target!.id == product.id) ??
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

  // This function encapsulates the common logic for updating order lines
  void _updateOrderLine(Product product, Function(OrderLine) updateFunction) {
    if (currentCart == null) return;

    // Check if the item already exists in the cart
    int index = findProductIndex(product);
    if (index >= 0) {
      final orderLineIndex = currentCart!.orderLines
          .indexWhere((element) => element.product.target!.id == product.id);

      // Use the provided update function to modify the order line
      updateFunction(currentCart!.orderLines[orderLineIndex]);

      _orderLineRepo.insertOrderLine(currentCart!.orderLines[orderLineIndex]);
    }
    // Refresh the order
    notifyListeners();
  }

  void updateDiscount(Product product, double discount) {
    _updateOrderLine(product, (orderLine) {
      orderLine.discount = discount;
    });
  }

  void updateQuantity(Product product, double quantity) {
    _updateOrderLine(product, (orderLine) {
      orderLine.quantity = quantity;
    });
  }
  
  /// expect issue here
  void removeAllOrders() {
    if (currentCart != null) {
      // Clear order lines in RAM
      currentCart!.orderLines.clear();

      // Persist changes to ObjectBox
      _activeOrderBox.updateActiveOrder(currentCart!);

      // Notify listeners about the change
      notifyListeners();
    }
  }
}
