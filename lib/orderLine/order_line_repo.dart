
import 'package:objectbox/objectbox.dart';
import 'package:testooo/orderLine/order_line.dart';

class OrderLineRepo {
  final Box<OrderLine> _orderLineBox;

  OrderLineRepo(this._orderLineBox);


  /// some methods to get order line from db
  List<OrderLine> getAll() {
    return _orderLineBox.getAll();
  }

  OrderLine? getOrderLineById(int id) {
    return _orderLineBox.get(id);
  }

  /// some methods to insert order Line to db
  void insertOrderLine(OrderLine orderLine) {
    _orderLineBox.put(orderLine);
  }

  ///  some methods to delete an order line
  void deleteOrderLine(OrderLine orderLine) {
    _orderLineBox.remove(orderLine.id);
  }
}
