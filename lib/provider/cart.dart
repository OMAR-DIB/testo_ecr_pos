import 'package:testooo/order/active_order.dart';

class Cart {
  ActiveOrder? savedOrder;
  List<ActiveOrder> orders = [];

  Cart({this.savedOrder, List<ActiveOrder>? initialOrders}) {
    if (initialOrders != null) {
      orders = initialOrders;
    }
  }
}
