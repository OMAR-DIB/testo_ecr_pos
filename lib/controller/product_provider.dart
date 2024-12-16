import 'package:flutter/material.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/repo/product_repo.dart';

class ProductProvider extends ChangeNotifier{
  final productBox = gloablObx.store.box<Product>();
  final ProductRepository _repository;
  List<Product> _products = [];

  ProductProvider(this._repository);

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _products = await _repository.getAllProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _repository.addProduct(product);
    await fetchProducts();
  }
}