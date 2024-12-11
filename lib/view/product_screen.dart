import 'package:flutter/material.dart';
import 'package:testooo/controller/product_provider.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/product.dart';
import 'package:provider/provider.dart';
import 'package:testooo/repo/product_repo.dart';
import 'package:testooo/view/show_product.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final TextEditingController productController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(ProductRepository(gloablObx.store.box<Product>())) 
      ..fetchProducts(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Product Page'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ShowProduct()),
                  );
                },
                icon: const Icon(Icons.show_chart),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: productController,
                  decoration: const InputDecoration(labelText: 'Product'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String product = productController.text;
                    String description = descriptionController.text;
                    String priceText = priceController.text;

                    if (product.isNotEmpty && priceText.isNotEmpty) {
                      double price = double.tryParse(priceText) ?? 0;
                      Product newProduct = Product(
                        name: product,
                        description: description,
                        price: price,
                      );
                      Provider.of<ProductProvider>(context, listen: false)
                          .addProduct(newProduct);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product Saved!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill required fields')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
