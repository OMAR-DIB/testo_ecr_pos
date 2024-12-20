import 'package:flutter/material.dart';
import 'package:testooo/controller/cart_item_controller.dart';
import 'package:testooo/controller/product_provider.dart';
import 'package:testooo/main.dart';
import 'package:testooo/models/product.dart';
import 'package:provider/provider.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/repo/product_repo.dart';
import 'package:testooo/view/report_page.dart';
import 'package:testooo/view/show_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            ProductRepository(gloablObx.store.box<Product>()),
          )..fetchProducts(),
        ),
        ChangeNotifierProvider(create: (_) => CartItemController()),
      ],
      child: Builder(
        builder: (context) {
          final TextEditingController productController =
              TextEditingController();
          final TextEditingController descriptionController =
              TextEditingController();
          final TextEditingController priceController = TextEditingController();
          final TextEditingController tvaController = TextEditingController();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(
                  255, 31, 110, 54), // AppBar background color

              title: const Text('Add Product'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ReportPage(),),
                    );
                  },
                  icon: const Icon(Icons.data_thresholding),
                  color: Colors.white,
                ),
                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(value: provider),
                                ChangeNotifierProvider(
                                  create: (_) => CartItemController(),
                                ),
                              ],
                              child: const ShowProduct(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.show_chart,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add a New Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: productController,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            prefixIcon: const Icon(Icons.shopping_bag),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color:
                                    Colors.green, // Set your desired color here
                                width: 2.0, // Thickness of the border
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color:
                                    Colors.green, // Set your desired color here
                                width: 2.0, // Thickness of the border
                              ),
                            ),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color:
                                    Colors.green, // Set your desired color here
                                width: 2.0, // Thickness of the border
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: tvaController,
                          decoration: InputDecoration(
                            labelText: 'tva',
                            prefixIcon: const Icon(Icons.shopping_bag),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color:
                                    Colors.green, // Set your desired color here
                                width: 2.0, // Thickness of the border
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              String product = productController.text;
                              String description = descriptionController.text;
                              String priceText = priceController.text;
                              String tvaText = tvaController.text;

                              if (product.isNotEmpty && priceText.isNotEmpty) {
                                double price = double.tryParse(priceText) ?? 0;
                                double tva = double.tryParse(tvaText) ?? 0;
                                Product newProduct = Product(
                                  name: product,
                                  description: description,
                                  price: price,
                                  tva: tva,
                                );
                                Provider.of<ProductProvider>(context,
                                        listen: false)
                                    .addProduct(newProduct);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Product Saved!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                productController.clear();
                                descriptionController.clear();
                                priceController.clear();
                                tvaController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill required fields'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.save,
                              size: 18,
                              color: Colors.black,
                            ), // Smaller icon size
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black), // Smaller font size
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 31, 110, 54), // Custom color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, // Adjusted horizontal padding
                                vertical: 8, // Adjusted vertical padding
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
