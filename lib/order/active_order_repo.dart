
import 'package:objectbox/objectbox.dart';
import 'package:testooo/order/active_order.dart';

class ActiveOrderRepo {
  final Box<ActiveOrder> _activeOrderBox;

  ActiveOrderRepo({required Box<ActiveOrder> activeOrderBox}) : _activeOrderBox = activeOrderBox;

  /// some methods to get active order from db
  ActiveOrder? getActiveOrderById(int id) {
    return _activeOrderBox.get(id);
  }

  List<ActiveOrder> getAllActiveOrders() {
    return _activeOrderBox.getAll();
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
}