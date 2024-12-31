// import 'package:testooo/order/active_order.dart';
// import 'package:testooo/order/active_order_repo.dart';
// import 'package:testooo/orderLine/order_line_repo.dart';

// class CartCache {

//   /// The in-memory cache for active orders
//   final List<ActiveOrder> _orders = [];

//   /// The selected order in the cache
//   ActiveOrder? selectedOrder;

//   /// The repositories
//   final ActiveOrderRepo _activeOrdersRepo;
//   final OrderLineRepo _orderLinesRepo;

//   CartCache(this._activeOrdersRepo, this._orderLinesRepo);

//   /// Initialize the cache by loading data from the database
//   Future<void> initialize() async {
//     _orders.clear();
//      _orders.addAll(await _activeOrdersRepo.getByModeAsync(OrdersMode.TakeAway));
//     if (_orders.isNotEmpty) {
//       selectedOrder = _orders.first;
//     } else {
//       // Create a new order if none exists
//       selectedOrder = ActiveOrder(id: 0, mode: 'none');
//       //await 
//       _activeOrdersRepo.insertActiveOrder(selectedOrder!);
//       _orders.add(selectedOrder!);
//     }
//   }

// }