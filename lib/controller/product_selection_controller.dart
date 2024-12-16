import 'package:flutter/material.dart';
import 'package:testooo/models/product.dart';


// class ProductSelectionController extends ChangeNotifier {
//   Product? _selectedProduct;
//   final Map<Product, int> _productQuantities = {}; // Product -> Quantity

//   Product? get selectedProduct => _selectedProduct;

//   // List of products with quantities for UI purposes
//   List<MapEntry<Product, int>> get clickedProducts => _productQuantities.entries.toList();

//   // Total price calculation based on quantities
//   double get totalPrice => _productQuantities.entries.fold(
//         0,
//         (sum, entry) => sum + (entry.key.price * entry.value),
//       );

//   // Select or increment product quantity
//   void selectProduct(Product product) {
//     _selectedProduct = product;

//     if (_productQuantities.containsKey(product)) {
//       // Increment quantity if the product already exists
//       _productQuantities[product] = _productQuantities[product]! + 1;
//     } else {
//       // Add new product with quantity 1
//       _productQuantities[product] = 1;
//     }

//     notifyListeners();
//   }

//   // Clear all selected products
//   void clearSelection() {
//     _productQuantities.clear();
//     notifyListeners();
//   }

//   // Decrease quantity or remove product
//   void removeProduct(Product product) {
//     if (_productQuantities.containsKey(product)) {
//       if (_productQuantities[product]! > 1) {
//         _productQuantities[product] = _productQuantities[product]! - 1;
//       } else {
//         _productQuantities.remove(product);
//       }
//       notifyListeners();
//     }
//   }
// }
