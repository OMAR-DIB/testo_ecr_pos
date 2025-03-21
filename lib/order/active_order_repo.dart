

import 'package:testooo/constant/order_mode.dart';
import 'package:testooo/objectbox.g.dart';
import 'package:testooo/order/active_order.dart';

class ActiveOrderRepo {
  final Box<ActiveOrder> _activeOrderBox;

  ActiveOrderRepo(this._activeOrderBox);
  /// some methods to get active order from db
  ActiveOrder? getActiveOrderById(int id) {
    return _activeOrderBox.get(id);
  }

  List<ActiveOrder> getAllActiveOrders() {
    return _activeOrderBox.getAll();
  }


  /// Get all active orders with a specific mode
  List<ActiveOrder> getActiveOrdersByMode(OrderMode mode) {
    final query = _activeOrderBox.query(ActiveOrder_.mode.equals(mode.name)).build();
    final orders = query.find();
    query.close();
    return orders;
  }

  /// some methods to insert active order to db
  void insertActiveOrder(ActiveOrder activeOrder) {
    _activeOrderBox.put(activeOrder);
  }

  /// some methods to update active order in db
  void updateActiveOrder(ActiveOrder activeOrder) {
    _activeOrderBox.put(activeOrder);
  }

  /// some methods to delete active order from db
  void deleteActiveOrder(ActiveOrder activeOrder) {
    _activeOrderBox.remove(activeOrder.id);
  }

  void deleteAll(){
    _activeOrderBox.removeAll();
  }

  int countActiveOrder() {
    return _activeOrderBox.count();
  }

  // some methods to get all carts from db
  // List<ActiveOrder> getAllCarts() {
  //   final query = _activeOrderBox.query(ActiveOrder_.mode.equals(OrderMode.cart.name)).build();
  //   final carts = query.find();
  //   query.close();
  //   return carts;
  // }
}