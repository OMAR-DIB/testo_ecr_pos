import 'package:objectbox/objectbox.dart';
import 'package:testooo/orderLine/order_line.dart';

import '../../utils/calculation_utils.dart';
// import '../order_line/order_line.dart';

@Entity()
class ActiveOrder {
  /// Product id
  @Id()
  int id = 0;

  /// Order mode
  String mode;

  

  /// Order lines
  ToMany<OrderLine> orderLines = ToMany<OrderLine>();

  /// Constructor
  ActiveOrder({
    required this.mode,
  });

  /// String representation of the order
  @override
  String toString() {
    return 'ActiveOrder{id: $id, mode: $mode, orderLines: $orderLines}';
  }

  /// Total price of the order
  double get total {
    double total = 0;
    for (final orderLine in orderLines) {
      total += orderLine.total;
    }
    return CalculationUtils.fixPrecision(total, 2);
  }

  // total discount of the order
  double get totalDiscount {
    double totalDiscount = 0;
    for (final orderLine in orderLines) {
      totalDiscount += orderLine.discount;
    }
    return CalculationUtils.fixPrecision(totalDiscount, 2);
  }

  /// Total VAT amount of the order
  double get vatAmount {
    double vatAmount = 0;
    for (final orderLine in orderLines) {
      vatAmount += orderLine.vatAmount;
    }
    return CalculationUtils.fixPrecision(vatAmount, 2);
  }

  /// Items count in the order
  double get itemsCount {
    double count = 0;
    for (final orderLine in orderLines) {
      count += orderLine.quantity;
    }
    return count;
  }
}