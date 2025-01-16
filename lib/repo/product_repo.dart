import '../models/product.dart';

import '../objectbox.g.dart';

class ProductRepository {
  final Box<Product> _productBox;

  ProductRepository(this._productBox);

  List<Product> getAllProducts()  {
    return _productBox.getAll();
  }

  Future<void> addProduct(Product product) async {
    _productBox.put(product);
  }

  Future<void> deleteProduct(int id) async {
    _productBox.remove(id);
  }

}
