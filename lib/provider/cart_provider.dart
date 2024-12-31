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

  /// List of order lines and Active orders with their getter
  List<ActiveOrder> _orders = [];

  get orders => _orders;

  ActiveOrder? savedOrder;

  CartProvider(
      {required ActiveOrderRepo activeOrderBox,
      required OrderLineRepo orderLineRepo})
      : _activeOrderBox = activeOrderBox,
        _orderLineRepo = orderLineRepo{
       _refreshOrder();
        }


  /// refresh order with every opperation and on start getting the order by mode
  void _refreshOrder() {
    _orders = _activeOrderBox.getActiveOrdersByMode(OrderMode.delivery);
    if (_orders.isNotEmpty) {
      savedOrder = _orders.first;
    } else {
      // create new order if none exists

      savedOrder = ActiveOrder(id: 0, mode: OrderMode.delivery.name);
      _activeOrderBox.insertActiveOrder(savedOrder!);
    }
    notifyListeners();
  }

  // find product index if no product -1
  int findProductIndex(Product product) {
    return savedOrder?.orderLines.indexWhere((element) => element.product.target!.id == product.id) ?? -1;
  }


  /// add order to cart from product
  void addOrder(Product product) {
    // if no saved order, create a new one
    savedOrder ??= ActiveOrder(id: 0, mode: OrderMode.delivery.name);

    // check if the item already exists in the cart or not
    int index = findProductIndex(product);
    // if item already in the cart, increase its quantity
    if (index >= 0) {
      final index = savedOrder!.orderLines
          .indexWhere((element) => element.product.target!.id == product.id);
      savedOrder!.orderLines[index].quantity += 1;

      // update the order line
      _orderLineRepo.insertOrderLine(savedOrder!.orderLines[index]);
    } else {
      savedOrder!.orderLines.add(OrderLine(id: 0, quantity: 1));
      savedOrder!.orderLines.last.product.target = product;

      // insert the selected order
      _activeOrderBox.insertActiveOrder(savedOrder!);
    }
    // refresh the order
    _refreshOrder();
  }

  void removeOrderLine(Product product) {
    // if no saved order, return
    if (savedOrder == null) return;

    // check if the item already exists in the cart or not
    int index = findProductIndex(product);
    // if item already in the cart, increase its quantity
    if (index >= 0) {
      final index = savedOrder!.orderLines
          .indexWhere((element) => element.product.target!.id == product.id);
      if (savedOrder!.orderLines[index].quantity > 1) {
        savedOrder!.orderLines[index].quantity -= 1;
      } else {
        savedOrder!.orderLines.removeAt(index);
      }
      _orderLineRepo.deleteOrderLine(savedOrder!.orderLines[index]);
    }
    // refresh the order
    _refreshOrder();
  }

  void removeOrder(){
    if(savedOrder != null){
      _activeOrderBox.deleteActiveOrder(savedOrder!);
      savedOrder = null;
    }else{
      return;
    }
    _refreshOrder();
  }

  double productQuantity(Product product) {
    if (savedOrder == null) return 0;

    // check if the item already exists in the cart or not
    int index = findProductIndex(product);
    // if item already in the cart, increase its quantity
    if (index >= 0) {
      final index = savedOrder!.orderLines
          .indexWhere((element) => element.product.target!.id == product.id);
      return savedOrder!.orderLines[index].quantity;
    }
    return 0;
  }
}
