import 'package:flutter/material.dart';
import 'package:testooo/models/product.dart';


class ProductSelectionController extends ChangeNotifier {
  Product? _selectedProduct;
  final List<Product> _clickedProducts = [];

  Product? get selectedProduct => _selectedProduct;
  List<Product> get clickedProducts => List.unmodifiable(_clickedProducts); // Read-only list
  double get totalPrice => _clickedProducts.fold(0, (sum, item) => sum + item.price);

  void selectProduct(Product product) {
    _selectedProduct = product;
    _clickedProducts.add(product);
    notifyListeners();
  }
}

